import http from "k6/http";
import { check, group, sleep } from "k6";
import { Counter, Rate, Trend } from "k6/metrics";
import exec from 'k6/execution';

export let options = {
    systemTags: ['status', 'method', 'url', 'scenario', 'group'],
    discardResponseBodies: true,
    scenarios:{
        make_post:{
            executor: 'shared-iterations',
            exec: 'comment',
            vus: 1,
            iterations: 100
        },
    },
    noCookiesReset: true,
};

// Custom metrics
// We instantiate them before our main function
let successful_req = new Counter("successful_req");
let check_failure_rate = new Rate("check_failure_rate");
let time_to_first_byte = new Trend("time_to_first_byte", true);
let url = "http://localhost:3000";
const params = {
    headers: {
      'Content-Type': 'application/json',
    },
};
//setup function runs only once
//logs in for the cookie setup
//creates a course for the url to be passed down to the virtual users
export function setup() {
    const jar = http.cookieJar();
    //Login step -----------
    let payload = JSON.stringify({
        email: 'users1@email.com',
        name:'users1',
    });

    let res = http.post(url+"/login", payload, params);
    let login_url = res.url;
    let check_res = check(res, {
        "200 requests": (r) => r.status >= 200 && r.status <300,
    });
    let cookie = jar.cookiesForURL(login_url);

    if (check_res) {
        successful_req.add(1);
    }
    check_failure_rate.add(!check_res, { page: "login" });
    time_to_first_byte.add(res.timings.waiting, { ttfbURL: res.url });

    //Create course step --------
    payload = JSON.stringify({
        name:'load_testing_course'
    });

    res = http.post(url+"/courses", payload, params);
    check_res = check(res, {
        "200 requests": (r) => r.status >= 200 && r.status <300,
    });
    let course_url = url
    if (check_res) {
        successful_req.add(1);
        course_url = res.url;
    }
    check_failure_rate.add(!check_res, { page: "course" });
    time_to_first_byte.add(res.timings.waiting, { ttfbURL: res.url });

    //Creart post step ---------
    payload = JSON.stringify({
        title:'post'+exec.instance.iterationsCompleted,
        body:'load_testing_post_body'
    });

    res = http.post(course_url+"/posts", payload, params);
    check_res = check(res, {
        "200 requests": (r) => r.status >= 200 && r.status <300,
    });
    let post_url = url;
    if (check_res) {
        successful_req.add(1);
        post_url = res.url;
    }
    check_failure_rate.add(!check_res, { page: "login" });
    time_to_first_byte.add(res.timings.waiting, { ttfbURL: res.url });

    return { purl: post_url,curl: course_url, cook: cookie };

}

//makes the assumption that user exists and course exists
//user is user1, email is user1@email.com
//course is load_testing_course
export function comment(data) {
    const jar = http.cookieJar();
    jar.set(data.purl, "_app_session", data.cook._app_session);
    let course_url = data.purl;

    const params = {
        headers: {
          'Content-Type': 'application/json',
        },
    };

    let payload = JSON.stringify({
        title:'post'+exec.instance.iterationsCompleted,
        body:'load_testing_post_body'
    });

    let res = http.post(course_url+"/posts", payload, params);
    let check_res = check(res, {
        "200 requests": (r) => r.status >= 200 && r.status <300,
    });
    if (check_res) {
        successful_req.add(1);
    }
    check_failure_rate.add(!check_res, { page: "login" });
    time_to_first_byte.add(res.timings.waiting, { ttfbURL: res.url });
}

export function teardown(data){
    const jar = http.cookieJar();
    jar.set(data.curl, "_app_session", data.cook._app_session);
    let course_url = data.curl;
    http.del(course_url);
}