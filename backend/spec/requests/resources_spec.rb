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
    it "リソース一覧API" do
      get resources_path
      expect(response).to have_http_status(200)
    end

    it "リソース一覧API(BG指定)" do
      get resources_path("q[balancing_group_id]"=>1)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /v1/resources/:id", autodoc: true do
    it "リソース表示API(BGリソース)" do
      get resource_path(@resource_self.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /v1/resources/:id", autodoc: true do
    it "リソース表示API(JEPXスポットリソース)" do
      get resource_path(@resource_jepx_spot.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /v1/resources/:id", autodoc: true do
    it "リソース表示API(JEPX1時間前リソース)" do
      get resource_path(@resource_jepx_one_hour.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /v1/resources/:id", autodoc: true do
    it "リソース表示API(常時バックアップリソース)" do
      get resource_path(@resource_jbu.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /v1/resources/:id", autodoc: true do
    it "リソース表示API(FITリソース)" do
      get resource_path(@resource_fit.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /v1/resources/:id", autodoc: true do
    it "リソース表示API(相対リソース)" do
      get resource_path(@resource_matching.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /v1/resources", autodoc: true do
    it "リソース登録API(BGリソース)" do
      post resources_path, params: { resource: attributes_for(:resource_self, bg_member_id: @balancing_group.bg_members.first.id).as_json }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /v1/resources", autodoc: true do
    it "リソース登録API(JEPXスポットリソース)" do
      post resources_path, params: { resource: attributes_for(:resource_jepx_spot, bg_member_id: @balancing_group.bg_members.first.id).as_json }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /v1/resources", autodoc: true do
    it "リソース登録API(JEPX1時間前リソース)" do
      post resources_path, params: { resource: attributes_for(:resource_jepx_one_hour, bg_member_id: @balancing_group.bg_members.first.id).as_json }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /v1/resources", autodoc: true do
    it "リソース登録API(JBUリソース)" do
      post resources_path, params: { resource: attributes_for(:resource_jbu, bg_member_id: @balancing_group.bg_members.first.id).as_json }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /v1/resources", autodoc: true do
    it "リソース登録API(FITリソース)" do
      post resources_path, params: { resource: attributes_for(:resource_fit, bg_member_id: @balancing_group.bg_members.first.id).as_json }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /v1/resources", autodoc: true do
    it "リソース登録API(相対リソース)" do
      post resources_path, params: { resource: build(:resource_matching, bg_member_id: @balancing_group.bg_members.first.id).as_json }
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /v1/resources/:id", autodoc: true do
    it "リソース更新API(BGリソース)" do
      @resource_self.code = "XXXXX"
      @resource_self.name = "test update"
      patch resource_path(@resource_self.id), params: { resource: @resource_self.as_json }
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /v1/resources/:id", autodoc: true do
    it "リソース更新API(JEPXスポットリソース)" do
      @resource_jepx_spot.code = "XXXXX"
      @resource_jepx_spot.name = "test update"
      patch resource_path(@resource_jepx_spot.id), params: { resource: @resource_jepx_spot.as_json }
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /v1/resources/:id", autodoc: true do
    it "リソース更新API(JEPX1時間前リソース)" do
      @resource_jepx_one_hour.code = "XXXXX"
      @resource_jepx_one_hour.name = "test update"
      patch resource_path(@resource_jepx_one_hour.id), params: { resource: @resource_jepx_one_hour.as_json }
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /v1/resources/:id", autodoc: true do
    it "リソース更新API(JBUリソース)" do
      @resource_jbu.code = "XXXXX"
      @resource_jbu.name = "test update"
      @resource_jbu.jbu_contracts
      patch resource_path(@resource_jbu.id), params: { resource: @resource_jbu.as_json }
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /v1/resources/:id", autodoc: true do
    it "リソース更新API(FITリソース)" do
      @resource_fit.code = "XXXXX"
      @resource_fit.name = "test update"
      patch resource_path(@resource_fit.id), params: { resource: @resource_fit.as_json }
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /v1/resources/:id", autodoc: true do
    it "リソース更新API(相対リソース)" do
      @resource_matching.code = "XXXXX"
      @resource_matching.name = "test update"
      @resource_matching.matching_trade_settings.build attributes_for(:matching_trade_setting, day_of_week_pattern: "3")
      patch resource_path(@resource_matching.id), params: { resource: @resource_matching.as_json }
      expect(response).to have_http_status(200)
    end
  end

end
