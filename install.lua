local expect = require "cc.expect".expect
local PrimeUI={}do local b={}local c;function PrimeUI.addTask(d)expect(1,d,"function")local e={coro=coroutine.create(d)}b[#b+1]=e;_,e.filter=coroutine.resume(e.coro)end;function PrimeUI.resolve(...)coroutine.yield(b,...)end;function PrimeUI.clear()term.setCursorPos(1,1)term.setCursorBlink(false)term.setBackgroundColor(colors.black)term.setTextColor(colors.white)term.clear()b={}c=nil end;function PrimeUI.setCursorWindow(f)expect(1,f,"table","nil")c=f and f.restoreCursor end;function PrimeUI.getWindowPos(f,g,h)if f==term then return g,h end;while f~=term.native()and f~=term.current()do if not f.getPosition then return g,h end;local i,j=f.getPosition()g,h=g+i-1,h+j-1;_,f=debug.getupvalue(select(2,debug.getupvalue(f.isColor,1)),1)end;return g,h end;function PrimeUI.run()while true do if c then c()end;local k=table.pack(os.pullEvent())for _,l in ipairs(b)do if l.filter==nil or l.filter==k[1]then local m=table.pack(coroutine.resume(l.coro,table.unpack(k,1,k.n)))if not m[1]then error(m[2],2)end;if m[2]==b then return table.unpack(m,3,m.n)end;l.filter=m[2]end end end end;function PrimeUI.label(f,g,h,n,o,p)expect(1,f,"table")expect(2,g,"number")expect(3,h,"number")expect(4,n,"string")o=expect(5,o,"number","nil")or colors.white;p=expect(6,p,"number","nil")or colors.black;f.setCursorPos(g,h)f.setTextColor(o)f.setBackgroundColor(p)f.write(n)end;function PrimeUI.scrollBox(f,g,h,q,r,s,t,u,o,p)expect(1,f,"table")expect(2,g,"number")expect(3,h,"number")expect(4,q,"number")expect(5,r,"number")expect(6,s,"number")expect(7,t,"boolean","nil")expect(8,u,"boolean","nil")o=expect(9,o,"number","nil")or colors.white;p=expect(10,p,"number","nil")or colors.black;if t==nil then t=true end;local v=window.create(f==term and term.current()or f,g,h,q,r)v.setBackgroundColor(p)v.clear()local w=window.create(v,1,1,q-(u and 1 or 0),s)w.setBackgroundColor(p)w.clear()if u then v.setBackgroundColor(p)v.setTextColor(o)v.setCursorPos(q,r)v.write(s>r and"\31"or" ")end;g,h=PrimeUI.getWindowPos(f,g,h)PrimeUI.addTask(function()local x=1;while true do local k=table.pack(os.pullEvent())s=select(2,w.getSize())local y;if k[1]=="key"and t then if k[2]==keys.up then y=-1 elseif k[2]==keys.down then y=1 end elseif k[1]=="mouse_scroll"and k[3]>=g and k[3]<g+q and k[4]>=h and k[4]<h+r then y=k[2]end;if y and(x+y>=1 and x+y<=s-r)then x=x+y;w.reposition(1,2-x)end;if u then v.setBackgroundColor(p)v.setTextColor(o)v.setCursorPos(q,1)v.write(x>1 and"\30"or" ")v.setCursorPos(q,r)v.write(x<s-r and"\31"or" ")end end end)return w end;function PrimeUI.progressBar(f,g,h,q,o,p,z)expect(1,f,"table")expect(2,g,"number")expect(3,h,"number")expect(4,q,"number")o=expect(5,o,"number","nil")or colors.white;p=expect(6,p,"number","nil")or colors.black;expect(7,z,"boolean","nil")local function A(B)expect(1,B,"number")if B<0 or B>1 then error("bad argument #1 (value out of range)",2)end;f.setCursorPos(g,h)f.setBackgroundColor(p)f.setBackgroundColor(o)f.write((" "):rep(math.floor(B*q)))f.setBackgroundColor(p)f.setTextColor(o)f.write(z and"\x7F"or(" "):rep(q-math.floor(B*q)))end;A(0)return A end;function PrimeUI.horizontalLine(f,g,h,q,o,p)expect(1,f,"table")expect(2,g,"number")expect(3,h,"number")expect(4,q,"number")o=expect(5,o,"number","nil")or colors.white;p=expect(6,p,"number","nil")or colors.black;f.setCursorPos(g,h)f.setTextColor(o)f.setBackgroundColor(p)f.write(("\x8C"):rep(q))end;function PrimeUI.keyAction(C,D)expect(1,C,"number")expect(2,D,"function","string")PrimeUI.addTask(function()while true do local _,E=os.pullEvent("key")if E==C then if type(D)=="string"then PrimeUI.resolve("keyAction",D)else D()end end end end)end;function PrimeUI.textBox(f,g,h,q,r,n,o,p)expect(1,f,"table")expect(2,g,"number")expect(3,h,"number")expect(4,q,"number")expect(5,r,"number")expect(6,n,"string")o=expect(7,o,"number","nil")or colors.white;p=expect(8,p,"number","nil")or colors.black;local F=window.create(f,g,h,q,r)function F.getSize()return q,math.huge end;local function A(G)expect(1,G,"string")F.setBackgroundColor(p)F.setTextColor(o)F.clear()F.setCursorPos(1,1)local H=term.redirect(F)print(G)term.redirect(H)end;A(n)return A end;function PrimeUI.drawText(f,n,I,o,p)expect(1,f,"table")expect(2,n,"string")expect(3,I,"boolean","nil")o=expect(4,o,"number","nil")or colors.white;p=expect(5,p,"number","nil")or colors.black;f.setBackgroundColor(p)f.setTextColor(o)local H=term.redirect(f)local J=print(n)term.redirect(H)if I then local g,h=f.getPosition()local K=f.getSize()f.reposition(g,h,K,J)end;return J end;function PrimeUI.borderBox(f,g,h,q,r,o,p)expect(1,f,"table")expect(2,g,"number")expect(3,h,"number")expect(4,q,"number")expect(5,r,"number")o=expect(6,o,"number","nil")or colors.white;p=expect(7,p,"number","nil")or colors.black;f.setBackgroundColor(p)f.setTextColor(o)f.setCursorPos(g-1,h-1)f.write("\x9C"..("\x8C"):rep(q))f.setBackgroundColor(o)f.setTextColor(p)f.write("\x93")for L=1,r do f.setCursorPos(f.getCursorPos()-1,h+L-1)f.write("\x95")end;f.setBackgroundColor(p)f.setTextColor(o)for L=1,r do f.setCursorPos(g-1,h+L-1)f.write("\x95")end;f.setCursorPos(g-1,h+r)f.write("\x8D"..("\x8C"):rep(q).."\x8E")end;function PrimeUI.button(f,g,h,n,D,o,p,M)expect(1,f,"table")expect(2,g,"number")expect(3,h,"number")expect(4,n,"string")expect(5,D,"function","string")o=expect(6,o,"number","nil")or colors.white;p=expect(7,p,"number","nil")or colors.gray;M=expect(8,M,"number","nil")or colors.lightGray;f.setCursorPos(g,h)f.setBackgroundColor(p)f.setTextColor(o)f.write(" "..n.." ")PrimeUI.addTask(function()local N=false;while true do local O,P,Q,R=os.pullEvent()local S,T=PrimeUI.getWindowPos(f,g,h)if O=="mouse_click"and P==1 and Q>=S and Q<S+#n+2 and R==T then N=true;f.setCursorPos(g,h)f.setBackgroundColor(M)f.setTextColor(o)f.write(" "..n.." ")elseif O=="mouse_up"and P==1 and N then if Q>=S and Q<S+#n+2 and R==T then if type(D)=="string"then PrimeUI.resolve("button",D)else D()end end;f.setCursorPos(g,h)f.setBackgroundColor(p)f.setTextColor(o)f.write(" "..n.." ")end end end)end end;
local t = "CCDocker-Reloaded"
local w,h =term.getSize()
PrimeUI.clear()
PrimeUI.label(term.current(), 3, 2, t.." Installer")
PrimeUI.label(term.current(), 3, 4, "CCDocker-Reloaded/ccdocker")
PrimeUI.horizontalLine(term.current(), 3, 3, #(t.." Installer") + 2)
PrimeUI.borderBox(term.current(), 4, 7, w-8, 1)
local progress = PrimeUI.progressBar(term.current(), 4, 7, w-8, nil, nil, true)
local function Download()
    local FAIL = false
    local amt = 1/(6)
    local count = 0
    count = count +amt
    local R,err = http.get('https://api.github.com/repos/CCDocker-Reloaded/ccdocker/releases/latest')
    local d

    if R == nil then
      FAIL = "err geting latest: "..err
      d = "https://github.com/CCDocker-Reloaded/ccdocker/releases/download/alpha_2/ccdocker"
    else
      d = textutils.unserializeJSON(R.readAll()).assets[1].browser_download_url
    end
    
    progress(count)
    sleep()
    count = count +amt
    local r = http.get(d)
    local fd = (r.readAll())
    progress(count)
    sleep()
    count = count +amt
    local f = fs.open('ccdocker','w')
    f.write(fd)
    f.close()

    progress(count)
    sleep()

    if not fs.exists('/var/') then
        fs.makeDir('/var')
    end

    count = count +amt
    progress(count)
    sleep()

    local r,err = http.get('https://raw.githubusercontent.com/CCDocker-Reloaded/packages/main/manifest.lson')
    if r == nil then
      PrimeUI.resolve("download", "fail",err)
      printError("Manifest Download Failed")
      return false
    end
    local cont = textutils.unserialise(r.readAll())

    count = count +amt
    progress(count)
    sleep()
    f = fs.open('/var/manifest.lson',"w")
    f.write(textutils.serialise({m = cont ,t = os.epoch("utc") / (1000*60*60*24)}))
    f:close()
    r:close()

    progress(1)
    sleep()
    if FAIL then
      PrimeUI.resolve("download", "fail",FAIL)
    else
      PrimeUI.resolve("download", "done")
    end
end
PrimeUI.addTask(Download)
local _,c,err = PrimeUI.run()
if c == "fail" then
  PrimeUI.clear()
  PrimeUI.label(term.current(), 3, 2, t.." Installer: Download error",colors.red)
  PrimeUI.horizontalLine(term.current(), 3, 3, #(t.." Installer: Download error") + 2,colors.red)
  PrimeUI.label(term.current(), 3, 4, "CCDocker-Reloaded/ccdocker",colors.red)
  PrimeUI.borderBox(term.current(), 4, 6, w-8, h-8,colors.red)
  local scroller = PrimeUI.scrollBox(term.current(), 4, 6, w-8, h-8, 9000, true, true)
  PrimeUI.drawText(scroller, "Download error:\n"..err, true)
  
  PrimeUI.button(term.current(), 3, h-1, "done", "done")
  
  PrimeUI.keyAction(keys.enter, "done")
  PrimeUI.run()
end
PrimeUI.clear()