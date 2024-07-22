pragma solidity ^0.8.0;

contract BlogApp {

    uint16 public MAX_BLOG_LENGTH = 250;

    struct Blog {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    mapping(address => Blog[] ) public blogs;
    address public owner;

    // Define the events
    event BlogCreated(uint256 id, address author, string content, uint256 timestamp);
    event BlogLiked(address liker, address blogAuthor, uint256 blogId, uint256 newLikeCount);
    event BlogUnliked(address unliker, address blogAuthor, uint256 blogId, uint256 newLikeCount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "YOU ARE NOT THE OWNER!");
        _;
    }

    function changeBlogLength(uint16 newBlogLength) public onlyOwner {
        MAX_BLOG_LENGTH = newBlogLength;
    }

    function createBlog(string memory _blog) public {
        require(bytes(_blog).length <= MAX_BLOG_LENGTH, "Blog is too long!" );

        Blog memory newBlog = Blog({
            id: blogs[msg.sender].length,
            author: msg.sender,
            content: _blog,
            timestamp: block.timestamp,
            likes: 0
        });

        blogs[msg.sender].push(newBlog);

        // Emit the TweetCreated event
        emit BlogCreated(newBlog.id, newBlog.author, newBlog.content, newBlog.timestamp);
    }

    function likeBLog(address author, uint256 id) external {  
        require(blogs[author][id].id == id, "BLOG DOES NOT EXIST");

        blogs[author][id].likes++;

        // Emit the TweetLiked event
        emit BlogLiked(msg.sender, author, id, blogs[author][id].likes);
    }

    function unlikeBlog(address author, uint256 id) external {
        require(blogs[author][id].id == id, "BLOG DOES NOT EXIST");
        require(blogs[author][id].likes > 0, "BLOG HAS NO LIKES");
        
        blogs[author][id].likes--;

        emit BlogUnliked(msg.sender, author, id, blogs[author][id].likes );
    }

    function getBlog( uint _i) public view returns (Blog memory) {
        return blogs[msg.sender][_i];
    }

    function getAllBlogs(address _owner) public view returns (Blog[] memory ){
        return blogs[_owner];
    }

}


