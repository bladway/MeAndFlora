from locust import HttpUser, TaskSet, task, between
from requests_toolbelt.multipart.encoder import MultipartEncoder


class ApiUserBehavior(TaskSet):
    jwttoken = None

    def get_jwt(self):
        response = self.client.post(
            "/auth/anonymous",
            json={"ipAddress": "1.1.1.1"},
            headers={"Accept": "application/json", "Content-Type": "application/json"}
        )
        return response.json().get("jwt")

    @task
    def post_request(self):
        multipart_data = MultipartEncoder(
            fields={
                'geoDto': '{"type": "Point", "coordinates": [1.1, 1.2]}',
                'image': ('sobaka.jpg', open('sobaka.jpg', 'rb'), 'image/jpeg')
            }
        )

        headers = {
            'accept': '*/*',
            'jwt': self.get_jwt(),
            'Content-Type': multipart_data.content_type
        }

        response = self.client.post(
            url='/request/request',
            data=multipart_data,
            headers=headers
        )


class WebsiteUser(HttpUser):
    tasks = [ApiUserBehavior]
    wait_time = between(1,1)
    host = 'https://4e00-5-187-70-1.ngrok-free.app'


if __name__ == "__main__":
    import os
    os.system("locust -f main.py --users 100 --spawn-rate 0.5")