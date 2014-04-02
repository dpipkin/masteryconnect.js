#masteryconnect.js [![Build Status](https://travis-ci.org/rockymadden/masteryconnect.js.png?branch=master)](http://travis-ci.org/rockymadden/masteryconnect.js)
Functional wrapper for the MasteryConnect RESTful API. All publicly available functions are supported.

## Depending Upon
The project is available on the [Node Packaged Modules registry](https://npmjs.org/package/masteryconnect.js). Add the dependency in your package.json file:

```javascript
"dependencies": {
	"masteryconnect.js": "0.0.x"
}
```

## Usage
Create a user, update user, delete user, and then logout:
```coffeescript
student = student:
	first_name: 'test'
	last_name: 'test'
	student_number: 123456

masteryconnect.withSession((session) ->
	session.postStudent(student)
		.then((_) -> _.fold(((_) -> _.student.id), -1))
		.then((id) -> session.putStudent(id, student: first_name: 'billy'); id)
		.then((id) -> session.deleteStudent(id))
		.done()
)
```

NOTE: MasteryConnect uses a persisted token based authentication method and closing the session is not needed.

## License
```
The MIT License (MIT)

Copyright (c) 2013 Rocky Madden (http://rockymadden.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
