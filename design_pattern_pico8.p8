pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--Var

--function
function init()


end

function update()
    update_actor()
    update_camera()
end

function draw ()
    cls()
    draw_actor()

end

-->8
local list_actor={}
local list_particule={}
local screen={
    height = 127,
    width = 127
}

local camera={
    position={x=0,y=0},
    time_shake =0,
    oldposition={x=0,y=0},
    is_chake = false,
    is_smooth = false,
    shake_intensity = 2
}

function generate_actor( p_position_x , p_position_y , p_type , p_tag )

	if p_tag == nul then
		p_tag ="no define"
	end

	local actor={}

	actor.type = p_type
	actor.tag = p_tag

    actor.position ={
        x=p_position_x,
        y=p_position_y
        }

	actor.speed = 0.75
	actor.velocity = {x=0,y=0}

    actor.flip={
        vertical = false ,
        horizontal=false
        }

	actor.sprite = {
        height = 1,
        width = 1
        }

	actor.animation={
        state ="idle",
        idel={0},
        speed =0,
        timer =0,
        curent_animation={0},
        curent_frame =1
        }
	actor.box_collision={
        height =8,
        height =8
        }

	actor.dell = false
	
    add(actor_list,actor)
	return actor

end
function check_actor_collision (p_actor_a,p_actor_b)
  
  if p_actor_a == p_actor_b then 
  
    return false
  
  end  
  
  local dx =p_actor_a.position.x - p_actor_b.position.x
  local dy =p_actor_a.position.y - p_actor_b.position.y

  if abs(dx) < p_actor_a.box_collision.width + p_actor_b.box_collision.width then

        if abs(dy) < p_actor_a.box_collision.height + p_actor_b.box_collision.height then
            return true
        end
  end

  return false

end
function update_actor()
    for actor in all (list_actor) do
        move_actor(actor)
        update_animation_actor(actor)
    end    
end

function move_actor(p_actor)

    local oldposition={
        x = p_actor.position.x ,
        y = p_actor.position.y
        }

		p_actor.position.x	+= p_actor.velocity.x * p_actor.speed
		p_actor.position.y	+= p_actor.velocity.y * p_actor.speed

        if check_map_collision(p_actor) then
            p_actor.position.x = oldposition.x
            p_actor.position.y = oldposition.y
        end
end
function update_animation_actor(p_actor)

    p_actor.animation.curent_frame += p_actor.animation.speed

    if flr(actor.curent_frame) > #actor.sprite then

        actor.curent_frame = 1

    end
end

function check_map_collision(p_acteur)

  	local ct=false

    local x1=(p_acteur.x)/8
    local y1=(p_acteur.y)/8
    local x2=(p_acteur.x+7)/8
    local y2=(p_acteur.y+7)/8

    local a=fget(mget(x1,y1),0)
    local b=fget(mget(x1,y2),0)
    local c=fget(mget(x2,y2),0)
    local d=fget(mget(x2,y1),0)
    
    ct=a or b or c or d
  	return ct
end

function generate_particules ( p_number_particule , p_color , p_position_x , p_position_y )

	for i = 1 , p_number_particule do
	
		local particule = generate_actor(p_position_x,p_position_y,"particule")
		particule.colore = p_color
		particule.direction.x = rnd( 2 ) - 1
		particule.direction.y = rnd( 2 ) - 1
		particule.time = 1
		particule.dell = false
		add( list_particule , particule )
	end
end

function draw_actor()

	for i=#actor_list,1,-1 do

		local actor = actor_list[i]
      
		--check actor is not out of screen
		if actor.x > 0 and actor.x < screen.width and actor.y > 0 and actor.y < screen.height  then
			spr( 
                actor.animation.curent_animation[flr(actor.animation.curent_frame) ] ,
                actor.x ,
                actor.y ,
                actor.sprite.width ,
                actor.sprite.height ,
                actor.flip.horizontal ,
                actor.flip.vertical 
                )
		end
		if actor.dell  then
			del(actor_list,actor)
		end
	end
    camera(camera.position.x,camera.position.y)
end


function update_camera()
    camera_shake()
end
function camera_move(p_position_x,p_position_y)
    
    if(camera.is_smooth) then
        
        camera.x = lerp(camera.x,p_position_x,0.5)  
        camera.y = lerp(camera.y,p_position_y,0.5) 
    
    else

        camera.x = p_position_x
        camera.y = p_position_y 

    end    
end
function lerp( p_position , p_target_position , p_time )

 return (1-p_time) * p_target_position + p_time * p_position ;
 
end
function init_shake_camera (p_timer)
	
    camera.time_shake = p_timer
    camera.is_chake = true
    
    camera.oldposition.x = camera.position.x
    camera.oldposition.y= camera.position.y
end

function camera_shake ()

	if camera.time_shake > 0 then

		camera.position.x += rnd(2)-1 * camera.shake_intensity
		camera.position.y += rnd(2)-1 * camera.shake_intensity
		camera.time_shake -= 0.01
	
    elseif camera.time_shake <=0 and camera.is_chake then

		camera.x = camera.oldposition.x
		camera.y = camera.oldposition.y
        camera.is_chake = false

	end	
	
end
