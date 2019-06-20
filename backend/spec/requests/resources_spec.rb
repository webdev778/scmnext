require 'rails_helper'

RSpec.describe "Resources", type: :request do
  before(:each) do
    @balancing_group = create(:balancing_group_tokyo)
    @resource_self = create(:resource_self, bg_member_id: @balancing_group.bg_members.first.id)
    @resource_jepx_spot = create(:resource_jepx_spot, bg_member_id: @balancing_group.bg_members.first.id)
    @resource_jepx_one_hour = create(:resource_jepx_one_hour, bg_member_id: @balancing_group.bg_members.first.id)
    @resource_jbu = create(:resource_jbu, bg_member_id: @balancing_group.bg_members.first.id)
    @resource_fit = create(:resource_fit, bg_member_id: @balancing_group.bg_members.first.id)
    @resource_matching = create(:resource_matching, bg_member_id: @balancing_group.bg_members.first.id)
  end

  describe "GET /v1/resources", autodoc: true do
    it "リソースの一覧を返す" do
      get resources_path
      expect(response).to have_http_status(200)
    end

    it "BGを指定した場合は、BGで絞り込んだリソースの一覧を返す" do
      get resources_path("q[balancing_group_id]"=>1)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /v1/resources/:id", autodoc: true do
    it "リソースを表示する(BGリソース)" do
      get resource_path(@resource_self.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /v1/resources/:id", autodoc: true do
    it "リソースを表示する(JEPXスポットリソース)" do
      get resource_path(@resource_jepx_spot.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /v1/resources/:id", autodoc: true do
    it "リソースを表示する(JEPX1時間前リソース)" do
      get resource_path(@resource_jepx_one_hour.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /v1/resources/:id", autodoc: true do
    it "リソースを表示する(常時バックアップリソース)" do
      get resource_path(@resource_jbu.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /v1/resources/:id", autodoc: true do
    it "リソースを表示する(FITリソース)" do
      get resource_path(@resource_fit.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /v1/resources/:id", autodoc: true do
    it "リソースを表示する(相対リソース)" do
      get resource_path(@resource_matching.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /v1/resources", autodoc: true do
    it "リソースを登録する(BGリソース)" do
      post resources_path, params: { resource: {bg_member_id: @balancing_group.bg_members.first.id }.merge(attributes_for(:resource_jbu)) }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /v1/resources", autodoc: true do
    it "リソースを登録する(FITリソース)" do
      post resources_path, params: { resource: {bg_member_id: @balancing_group.bg_members.first.id }.merge(attributes_for(:resource_fit)) }
      expect(response).to have_http_status(200)
    end
  end
end
