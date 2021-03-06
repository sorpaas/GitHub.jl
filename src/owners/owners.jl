##############
# Owner Type #
##############

type Owner <: GitHubType
    typ::Nullable{GitHubString}
    email::Nullable{GitHubString}
    name::Nullable{GitHubString}
    login::Nullable{GitHubString}
    bio::Nullable{GitHubString}
    company::Nullable{GitHubString}
    location::Nullable{GitHubString}
    gravatar_id::Nullable{GitHubString}
    id::Nullable{Int}
    public_repos::Nullable{Int}
    owned_private_repos::Nullable{Int}
    total_private_repos::Nullable{Int}
    public_gists::Nullable{Int}
    private_gists::Nullable{Int}
    followers::Nullable{Int}
    following::Nullable{Int}
    collaborators::Nullable{Int}
    blog::Nullable{HttpCommon.URI}
    url::Nullable{HttpCommon.URI}
    html_url::Nullable{HttpCommon.URI}
    updated_at::Nullable{Dates.DateTime}
    created_at::Nullable{Dates.DateTime}
    date::Nullable{Dates.DateTime}
    hireable::Nullable{Bool}
    site_admin::Nullable{Bool}
end

Owner(data::Dict) = json2github(Owner, data)
Owner(login::AbstractString, isorg = false) = Owner(Dict("login" => login, "typ" => isorg ? "User" : "Organization"))

namefield(owner::Owner) = owner.login

typprefix(isorg) = isorg ? "orgs" : "users"

#############
# Owner API #
#############

isorg(owner::Owner) = get(owner.typ, "") == "Organization"

owner(owner_obj::Owner; options...) = owner(name(owner_obj), isorg(owner_obj); options...)

function owner(owner_obj, isorg = false; options...)
    result = gh_get_json("/$(typprefix(isorg))/$(name(owner_obj))"; options...)
    return Owner(result)
end

function users(; options...)
    results, page_data = gh_get_paged_json("/users"; options...)
    return map(Owner, results), page_data
end

function orgs(owner; options...)
    results, page_data = gh_get_paged_json("/users/$(name(owner))/orgs"; options...)
    return map(Owner, results), page_data
end

function followers(owner; options...)
    results, page_data = gh_get_paged_json("/users/$(name(owner))/followers"; options...)
    return map(Owner, results), page_data
end

function following(owner; options...)
    results, page_data = gh_get_paged_json("/users/$(name(owner))/following"; options...)
    return map(Owner, results), page_data
end

repos(owner::Owner; options...) = repos(name(owner), isorg(owner); options...)

function repos(owner, isorg = false; options...)
    results, page_data = gh_get_paged_json("/$(typprefix(isorg))/$(name(owner))/repos"; options...)
    return map(Repo, results), page_data
end
