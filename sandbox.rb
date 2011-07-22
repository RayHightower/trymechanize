require 'rubygems'
require 'mechanize'
require 'logger'
require 'rspec'


describe "screenscraper" do
  it "can find a search form on the page" do
    setup_search_form.should be
  end

  it "gets the right page" do
    agent = Mechanize.new { |a| a.log = Logger.new("mech.log") }
    agent.get("http://gutenberg.org/").body.should match("Gutenberg")
  end

  it "grabs data from a website" do
    goto_target_page.body.should match("United States Constitution")
  end

  it "follows the link to the US Constitution" do
    goto_target_page.link_with(:text => /United States Constitution/).click.body.should match("Download This eBook")
    
  end 
end

def setup_search_form
    agent = create_agent
    page = agent.get("http://www.gutenberg.org/")
    search_form = page.form_with(:action => "/ebooks/search/")
end

def create_agent
    agent = Mechanize.new { |a| a.log = Logger.new("mech.log") }
    agent.user_agent_alias = 'Mac Safari'
    agent
end

def goto_target_page
    search_form = setup_search_form
    search_form.field_with(:name => "query").value = "Constitution"
    search_results = create_agent.submit(search_form)
end
