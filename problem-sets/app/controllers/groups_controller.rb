class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :check_group_admin, only: [:edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @username = @group.users
    @needs = Need.where(group: @group, status: "Unresolved")

    items = @needs.pluck(:item_id).uniq

    @group_needs = []

    if !items.empty?

      items.each do |item|
        item = Item.find(item)
        needs = @needs.where(item_id: item)
        sum = needs.sum(:quantity)

        dict = {
            :item => item.name,
            :sum => sum
        }

        @group_needs.append(dict)
      end

    end

    @messages = Message.where(group: @group).order(:created_at).last(50)
    @message = current_user.messages.new
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  def get_users
    if params[:name].blank?
      respond_to do |format|
        format.html
        format.json {
          render json: User.where('email ilike ?', "%#{params[:q]}%")
                           .select('id, email as name')
        }
      end
    else

      group = Group.new
      group.name = params[:name]
      group.user = current_user
      group.status = "Unlocked"
      group.save

      admin_user_group = UserGroup.create(user: current_user, group: group)

      users = User.where(id: params[:search_user].split(","))

      users.each do |user|
        UserGroup.create(user: user, group: group)
      end

      redirect_to root_path
    end
  end

  def add_users
    respond_to do |format|
      format.html
      format.json {
        render json: User.where('email ilike ?', "%#{params[:q]}%")
                         .select('id, email as name')
      }
    end

    group = Group.find(params[:group_id])
    users = User.where(id: params[:search_user].split(","))
    puts group.name
    users.each do |user|
      UserGroup.create(user: user, group: group)
    end
    redirect_to root_path
  end


  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    @group.user = current_user
    @group.status = "Unlocked"

    @user_group = UserGroup.create(user: current_user, group: @group)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def lock_group
    @group = Group.find_by_id(params[:id])
    @group.status = "Locked"
    @group.save
    redirect_to @group
  end

  def unlock_group
    @group = Group.find_by_id(params[:id])
    @group.status = "Unlocked"
    @group.save
    redirect_to @group
  end

  private

    def check_group_admin
      if @group.user != current_user and !current_user.is_admin
        redirect_back(fallback_location: root_path)
      end
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :group_id)
    end
end
