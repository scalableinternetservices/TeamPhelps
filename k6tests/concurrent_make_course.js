import http from "k6/http";
import { check, group, sleep } from "k6";
import { Counter, Rate, Trend } from "k6/metrics";
import exec from 'k6/execution';
import uuid from './uuid.js';


export let options = {
    // vus: 100,
    stages: [
        { duration: '30s', target: 5 },
        { duration: '30s', target: 1000 },
        { duration: '30s', target: 5 },
    ],
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
export default function () {
    group("make_course", function () {
        //Login step -----------
        const jar = http.cookieJar();
        let url = "http://yuval3.eba-rpinrm9x.us-west-2.elasticbeanstalk.com";
        let payload = JSON.stringify({
            email: 'users1@email.com',
            name: 'users1',
        });

        const params = {
            headers: {
                'Content-Type': 'application/json',
            },
        };
        let res = http.post(url + "/login", payload, params);
        let check_res = check(res, {
            "200 requests": (r) => r.status >= 200 && r.status < 300,
        });
        if (check_res) {
            successful_req.add(1);
        }
        check_failure_rate.add(!check_res, { page: "login" });
        time_to_first_byte.add(res.timings.waiting, { ttfbURL: res.url });
        payload = JSON.stringify({
            name: "course " + uuid.v4()
        });

        res = http.post(url + "/courses", payload, params);
        check_res = check(res, {
            "200 requests": (r) => r.status >= 200 && r.status < 300,
        });
        if (check_res) {
            successful_req.add(1);
        }
        check_failure_rate.add(!check_res, { page: "login" });
        time_to_first_byte.add(res.timings.waiting, { ttfbURL: res.url });
    });
}