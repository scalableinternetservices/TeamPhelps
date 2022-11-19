import http from "k6/http";
import { check, group, sleep } from "k6";
import { Counter, Rate, Trend } from "k6/metrics";
import exec from 'k6/execution';

// const loginData = {"users":[{name:"users1", email:"users1@email.com"}]};

export let options = {
    vus: 100,
    iterations: 100,
    noCookiesReset: true,
};

// Custom metrics
// We instantiate them before our main function
let successful_req = new Counter("successful_req");
let check_failure_rate = new Rate("check_failure_rate");
let time_to_first_byte = new Trend("time_to_first_byte", true);

//makes the assumption that user exists and course exists
//user is user1, email is user1@email.com
//course is load_testing_course1
export default function() {
    group("make_post", function() {
        //Login step -----------
        const jar = http.cookieJar();
        let url = "http://phelps.eba-rpinrm9x.us-west-2.elasticbeanstalk.com/";
        let payload = JSON.stringify({
            email: 'users1@email.com',
            name:'users1',
        });
        
        const params = {
            headers: {
              'Content-Type': 'application/json',
            },
          };
        let res = http.post(url+"login", payload, params);
        let check_res = check(res, {
            "200 requests": (r) => r.status >= 200 && r.status <300,
        });
        if (check_res) {
            successful_req.add(1);
        }
        check_failure_rate.add(!check_res, { page: "login" });
        time_to_first_byte.add(res.timings.waiting, { ttfbURL: res.url });
        // sleep(2);
        //Create course step --------
        payload = JSON.stringify({
            name:'load_testing_course5'+exec.vu.idInInstance
        });

        res = http.post(url+"courses", payload, params);
        check_res = check(res, {
            "200 requests": (r) => r.status >= 200 && r.status <300,
        });
        let course_url = url
        if (check_res) {
            successful_req.add(1);
            course_url = res.url
        }
        // console.log(course_url + "actual "+res.url);
        check_failure_rate.add(!check_res, { page: "course" });
        time_to_first_byte.add(res.timings.waiting, { ttfbURL: res.url });
        
        // Create post step---------
        if(course_url != url){
            for(let i = 0 ; i < 100; i++){
                // console.log("should've made post?"+course_url);
                payload = JSON.stringify({
                    title:'post'+i,
                    body:'load_testing_post_body'
                });

                res = http.post(course_url+"/posts", payload, params);
                check_res = check(res, {
                    "200 requests": (r) => r.status >= 200 && r.status <300,
                });
                if (check_res) {
                    successful_req.add(1);
                }
                check_failure_rate.add(!check_res, { page: "login" });
                time_to_first_byte.add(res.timings.waiting, { ttfbURL: res.url });
            }
        }
    });
}