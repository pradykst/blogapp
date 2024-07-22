// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


//create accounts with nicknames(just like struct blog?)
//one like per user?owner cant like post(require )
//remove blog if more reportss and one report per user
//integrate with frontend?

contract BlogApp {

    uint16 public MAX_BLOG_LENGTH = 250;
    uint16 public MAX_REPORTS= 5;

    struct Blog {
        uint256 id;
        address author;
        string title;
        string content;
        uint256 timestamp;
        uint256 likes;
        uint256 report;
    }
    mapping(address => Blog[] ) public blogs;
    address public owner;

    // Define the events
    event BlogCreated(uint256 id, address author, string content, uint256 timestamp);
    event BlogLiked(address liker, address blogAuthor, uint256 blogId, uint256 newLikeCount);
    event BlogReported(address reporter, address blogAuthor, uint256 blogId, uint256 newReportCount);
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

    function changeReport(uint16 newReports) public onlyOwner {
        MAX_REPORTS = newReports;
    }

    function createBlog(string memory _title,string memory _blog) public {
        require(bytes(_blog).length <= MAX_BLOG_LENGTH, "Blog is too long!" );

        Blog memory newBlog = Blog({
            id: blogs[msg.sender].length,
            author: msg.sender,
            title: _title,
            content: _blog,
            timestamp: block.timestamp,
            likes: 0,
            report: 0
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

    function reportBlog(address author, uint256 id) external {  
        require(blogs[author][id].id == id, "BLOG DOES NOT EXIST");

        blogs[author][id].report++;

        
        emit BlogReported(msg.sender, author, id, blogs[author][id].report);
    }

    function unlikeBlog(address author, uint256 id) external {
        require(blogs[author][id].id == id, "BLOG DOES NOT EXIST");
        require(blogs[author][id].likes > 0, "BLOG HAS NO LIKES");
        
        blogs[author][id].likes--;

        emit BlogUnliked(msg.sender, author, id, blogs[author][id].likes );
    }

    function getBlog( uint _i) public view returns (Blog memory, uint256) {
        require(blogs[msg.sender][_i].report<MAX_REPORTS, "BLOG DOES NOT EXIST" );
        return (blogs[msg.sender][_i],blogs[msg.sender][_i].likes);

        
    }

    function getAllBlogs(address _owner) public view returns (Blog[] memory ){
        return blogs[_owner];

    }

}


