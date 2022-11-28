import http from "k6/http";
import { check, group, sleep } from "k6";
import { Counter, Rate, Trend } from "k6/metrics";
import exec from 'k6/execution';
import uuid from './uuid.js';
import { parseHTML } from 'k6/html';

export let options = {
    systemTags: ['status', 'method', 'url', 'scenario', 'group'],
    // discardResponseBodies: true,
    scenarios:{
        make_course:{
            executor: 'shared-iterations',
            exec: 'course',
            vus: 1,
            iterations: 10
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
let good_list = [];
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

    
    return { cook: cookie };
}

//makes the assumption that user exists and course exists
//user is user1, email is user1@email.com
//course is load_testing_course
export function course(data) {
    const jar = http.cookieJar();
    const params = {
        headers: {
          'Content-Type': 'application/json',
        },
    };

    //Create course step --------
    let payload = JSON.stringify({
        name:'course'+uuid.v4()
    });
    jar.set(url+"/courses", "_app_session", data.cook._app_session);

    let res = http.post(url+"/courses", payload, params);
    let check_res = check(res, {
        "200 requests": (r) => r.status >= 200 && r.status <300,
    });
    let course_url = url
    if (check_res) {
        successful_req.add(1);
        course_url = res.url;
        good_list.push(course_url);
    }
    // console.log(good_list);
    check_failure_rate.add(!check_res, { page: "course" });
    time_to_first_byte.add(res.timings.waiting, { ttfbURL: res.url });
}

export function teardown(data){
    const jar = http.cookieJar();
    const params = {
        headers: {
          'Content-Type': 'application/json',
        },
    };
    jar.set(url+"/courses", "_app_session", data.cook._app_session);
    let res = http.get(url+"/courses");
    let parsed_body = parseHTML(res.body);
    // console.log(res.body);
    let list_of_anchors = parsed_body.find('a').toArray();
    for (let i = 1; i < list_of_anchors.length; i++){
        let u = parsed_body.find('a').get(i).pathname();
        if (u.includes('/courses/')) {
            // console.log(u);
            res = http.del(url+u);
        }
    }
}
