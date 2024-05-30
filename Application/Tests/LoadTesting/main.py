from locust import HttpUser, TaskSet, task, between, HttpLocust
from requests_toolbelt.multipart.encoder import MultipartEncoder
from requests_toolbelt.adapters.source import SourceAddressAdapter


class ApiUserBehavior(TaskSet):
    jwttoken = None

    def get_jwt(self):
        response = self.client.post(
            "/auth/anonymousLogin",
            json={"ipAddress": "1.1.1.1"},
            headers={"Accept": "application/json", "Content-Type": "application/json"}
        )
        return response.json().get("jwt")

    @task
    def post_request(self):
        multipart_data = MultipartEncoder(
            fields={
                'geoDto': '{"type": "Point", "coordinates": [1.1, 1.2]}',
                'image': ('Oduvanchik.jpg', open('Oduvanchik.jpg', 'rb'), 'image/jpeg')
            }
        )

        headers = {
            'accept': '*/*',
            'jwt': self.get_jwt(),
            'Content-Type': multipart_data.content_type
        }

        response = self.client.post(
            url='/request/create',
            data=multipart_data,
            headers=headers
        )


class WebsiteUser(HttpUser):
    tasks = [ApiUserBehavior]
    wait_time = between(6,6)
    host = 'https://74f3-5-187-71-141.ngrok-free.app'


if __name__ == "__main__":
    import os
    os.system("locust -f main.py --users 6 --spawn-rate 3")