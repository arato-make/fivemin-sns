import consumer from "./consumer"

var posts;

consumer.subscriptions.create({channel: "TagChannel", room: "fdasf"}, {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('connected');
    posts = document.getElementById('posts');

    var deletePosts = function(){
      var times = posts.getElementsByClassName("created");
      for(let i = 0;i < times.length;i++){
        if (Date.now() - Date.parse(times[i].textContent) > 300000) {
          while(posts.children[i]){
            posts.removeChild(posts.children[i]);
          }
          return;
        }
      }
    };

    setInterval(deletePosts, 10000);
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    var post = document.getElementById("post-template").cloneNode(true);
    post.removeAttribute("hidden");
    post.removeAttribute("id");
    var username = post.getElementsByClassName("username")[0];
    username.appendChild(document.createTextNode(data['username']));

    var content = post.getElementsByClassName("content")[0];
    content.appendChild(document.createTextNode(data['content']));

    var created = post.getElementsByClassName("created")[0];
    created.appendChild(document.createTextNode(data['created']));

    var image = post.getElementsByClassName("image")[0];
    image.src = data['image'];

    console.log(data);

    document.getElementById("post_content").value = "";

    posts.prepend(post);
  },

  post: function() {
    return this.perform('post');
  }
});
