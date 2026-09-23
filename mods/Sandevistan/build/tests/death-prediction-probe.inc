      private var deathProbeStage:int = 0;
      private var deathProbeTicks:int = 0;
      private var deathProbeFails:int = 0;
      private var deathProbeChecks:int = 0;
      private function deathAssert(name:String, ok:Boolean, detail:String):void
      {
         deathProbeChecks++;
         if (!ok) deathProbeFails++;
         log("[DEATH-TEST] " + name + " " + (ok ? "PASS" : "FAIL") + " " + detail);
      }
      private function deathEnemy(className:String = "fe.unit.UnitRaider", id:String = "1"):Object
      {
         var cls:Class = ApplicationDomain.currentDomain.getDefinition(className) as Class;
         var u:Object = new cls(id, 10);
         u.putLoc(world.loc, world.gg.X + 200, world.gg.Y);
         world.loc.addObj(u); world.loc.units.push(u);
         u.sost = 1; u.hp = 10000; u.maxhp = 10000;
         u.armor = 0; u.marmor = 0; u.armor_qual = 0; u.armor_hp = 0;
         u.skin = 0; u.shithp = 0; u.shitArmor = 0;
         u.dexter = 0; u.dexterPlus = 0; u.dodge = 0;
         u.allVulnerMult = 1; u.invulner = false; u.stay = true;
         u.blood = 0; u.showNumbs = false; u.maxShok = 0;
         for (var i:int = 0; i < u.vulner.length; i++) u.vulner[i] = 1;
         return u;
      }
      private function deathRemove(u:Object):void
      {
         u.disabled = true; u.sost = 4;
         var index:int = world.loc.units.indexOf(u);
         if (index >= 0) world.loc.units.splice(index, 1);
         world.loc.remObj(u); u.remVisual();
      }
      private function deathBullet(u:Object, damage:Number = 100):Object
      {
         var cls:Class = ApplicationDomain.currentDomain.getDefinition("fe.weapon.Bullet") as Class;
         var b:Object = new cls(world.gg, u.X, u.Y - 20, null, false);
         b.damage = damage; b.tipDamage = 0; b.critCh = 0; b.critInvis = 0;
         b.miss = 0; b.precision = 0; b.probiv = 0; b.parr = [u];
         return b;
      }
      private function deathFormulaCase(name:String, type:int, armor:Number, magicArmor:Number, hpArmor:Number, crit:Number, worn:Boolean = false):void
      {
         var u:Object = deathEnemy();
         u.armor = armor; u.marmor = magicArmor; u.armor_qual = armor > 0 || magicArmor > 0 ? 1 : 0;
         u.armor_hp = hpArmor;
         var b:Object = deathBullet(u); b.tipDamage = type; b.critCh = crit; b.critDamMult = 2;
         var wh:Number = 0, wm:Number = 0;
         if (worn)
         {
            var wcls:Class = ApplicationDomain.currentDomain.getDefinition("fe.weapon.Weapon") as Class;
            var dataCls:Class = ApplicationDomain.currentDomain.getDefinition("fe.AllData") as Class;
            var weaponId:String = String(dataCls["d"].weapon[0].@id);
            log("[DEATH-TEST] weapon fixture=" + weaponId);
            b.weap = new wcls(world.gg, weaponId);
            wh = b.weap.hp; wm = b.weap.maxhp;
            b.weap.maxhp = 100; b.weap.hp = 25;
         }
         var predicted:Number = expectedDam(b, u, 100);
         var actual:Number = u.damage(100, type, b, false);
         deathAssert(name, Math.abs(predicted - actual) < 0.001, "expected=" + predicted + " native=" + actual);
         if (worn) { b.weap.hp = wh; b.weap.maxhp = wm; }
         deathRemove(u);
      }
      private function deathExtendedCases():void
      {
         var u:Object, b:Object, actual:Number, predicted:Number;
         for each (var type:int in [1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 100])
            deathFormulaCase("damage-type-" + type, type, 60, 15, 10000, 0);
         u = deathEnemy(); u.armor = 20; u.armor_qual = 1; u.armor_hp = 10000;
         b = deathBullet(u); world.pers.damPony = 1.5;
         predicted = expectedDam(b, u, 100); actual = u.damage(100, 0, b);
         deathAssert("species-before-armor", Math.abs(predicted - actual) < 0.001, "expected=" + predicted + " native=" + actual);
         world.pers.damPony = 1; deathRemove(u);

         for each (var shield:Boolean in [false, true])
         {
            u = deathEnemy();
            if (shield) { u.shithp = 150; u.shitArmor = 50; }
            else { u.armor = 70; u.armor_qual = 1; u.armor_hp = 150; }
            b = deathBullet(u);
            creditHit(b, 100); b.parr = [u]; creditHit(b, 100); b.parr = [u]; creditHit(b, 100);
            predicted = predDam[u];
            deathAssert("virtual-defense-is-read-only-" + shield, u.hp == 10000 && (shield ? u.shithp == 150 : u.armor_hp == 150), "realHP=" + u.hp);
            actual = 0;
            for (var j:int = 0; j < 3; j++) actual += u.damage(100, 0, b);
            deathAssert("consecutive-defense-break-" + shield, Math.abs(predicted - actual) < 0.001, "expected=" + predicted + " native=" + actual);
            restorePredDead(); deathRemove(u);
         }
         u = deathEnemy(); b = deathBullet(u); u.dexter = 1; u.dexterPlus = 0;
         b.tipBullet = 1; u.dodge = 1;
         deathAssert("full-dodge", expectedHitCh(b, u) == 0, "p=" + expectedHitCh(b,u));
         u.dexter = 0;
         deathAssert("zero-dex-bypasses-dodge", expectedHitCh(b,u) == 1, "p=" + expectedHitCh(b,u));
         u.dexter = 10; b.tipBullet = 0; b.precision = 0;
         deathAssert("zero-precision-bypasses-dex", expectedHitCh(b,u) == 1, "p=" + expectedHitCh(b,u));
         b.miss = 1;
         deathAssert("guaranteed-miss", expectedDam(b,u,100) == 0, "damage=" + expectedDam(b,u,100));
         b.miss = 0; u.invulner = true;
         deathAssert("invulnerable", expectedDam(b,u,100) == 0, "damage=" + expectedDam(b,u,100));
         u.invulner = false; b.parr = null; u.hp = 1;
         creditHit(b, 100);
         deathAssert("no-contact-no-credit", predDead[u] != true && predDam[u] == null, "credited=" + predDam[u]);
         restorePredDead(); deathRemove(u);

         u = deathEnemy(); b = deathBullet(u); u.armor = 200; u.armor_qual = 0.5; u.armor_hp = 0;
         predicted = expectedDam(b,u,100); actual = 0;
         for (j = 0; j < 2400; j++) { u.hp = 10000; actual += Math.max(0, u.damage(100,0,b)); }
         actual /= 2400;
         deathAssert("partial-coverage-floor", Math.abs(predicted - 50) < 0.001 && Math.abs(predicted - actual) < 5, "expected=" + predicted + " nativeMean2400=" + actual);
         deathRemove(u);

         u = deathEnemy(); b = deathBullet(u); u.armor = 115; u.armor_qual = 1; u.armor_hp = 0;
         world.testDam = false;
         predicted = expectedDam(b,u,100); actual = 0;
         for (j = 0; j < 2400; j++) { u.hp = 10000; u.udarBullet(b); actual += 10000 - u.hp; }
         actual /= 2400;
         deathAssert("random-spread-armor-threshold", Math.abs(predicted - 1.875) < 0.05 && Math.abs(actual - predicted) < 0.35, "expected=" + predicted + " analytic=1.875 nativeMean2400=" + actual);
         world.testDam = true; deathRemove(u);
         for each (var direction:int in [-1,1])
         {
            u = deathEnemy("fe.unit.UnitTurret", "arm"); b = deathBullet(u); b.dx = direction * u.storona;
            predicted = expectedDam(b,u,100); actual = u.damage(100,0,b);
            deathAssert("turret-direction-" + direction, Math.abs(predicted-actual)<0.001, "expected=" + predicted + " native=" + actual);
            deathRemove(u);
         }
         for each (type in [0, 12, 13, 100])
         {
            u = deathEnemy(); u.allVulnerMult = 0.5; b = deathBullet(u); b.tipDamage = type;
            predicted = expectedDam(b,u,100); actual = u.damage(100,type,b);
            deathAssert("global-vulnerability-" + type, Math.abs(predicted-actual)<0.001, "expected=" + predicted + " native=" + actual);
            deathRemove(u);
         }
         u = deathEnemy(); b = deathBullet(u); u.celUnit = null; u.doop = false; b.critInvis = 1;
         predicted = expectedDam(b,u,100); actual = u.damage(100,0,b);
         deathAssert("sneak-critical", Math.abs(predicted-actual)<0.001, "expected=" + predicted + " native=" + actual);
         deathRemove(u);
         u = deathEnemy(); u.hp = 500; b = deathBullet(u); b.tipDamage = 5; b.desintegr = 1;
         predicted = expectedDam(b,u,100); actual = u.damage(100,5,b);
         deathAssert("disintegration", Math.abs(predicted-actual)<0.001, "expected=" + predicted + " native=" + actual);
         deathRemove(u);
         u = deathEnemy(); b = deathBullet(u); b.tipDamage = 9; u.stay = false; u.inWater = 0; u.isLaz = 0;
         predicted = expectedDam(b,u,100); actual = u.damage(100,9,b);
         deathAssert("airborne-spark", Math.abs(predicted-actual)<0.001, "expected=" + predicted + " native=" + actual);
         deathRemove(u);

         // Actual WClub class: damage is set before the later bindMove collision.
         u = deathEnemy();
         var dataCls:Class = ApplicationDomain.currentDomain.getDefinition("fe.AllData") as Class;
         var clubCls:Class = ApplicationDomain.currentDomain.getDefinition("fe.weapon.WClub") as Class;
         var clubId:String = String(dataCls["d"].weapon.(@tip == 1)[0].@id);
         var savedWeapon:Object = world.gg.currentWeapon;
         var club:Object = new clubCls(world.gg, clubId);
         world.gg.currentWeapon = club; b = club.b;
         b.damage = 40; b.critCh = 0; b.critInvis = 0; b.tipDamage = 0; b.parr = null;
         freezeMeleeDamage();
         b.parr = [u]; freezeMeleeDamage(); freezeMeleeDamage();
         deathAssert("melee-later-contact", predDam[u] == 40 && b.damage == 0, "credited=" + predDam[u]);
         b.parr = null; b.damage = 40; freezeMeleeDamage(); b.parr = [u]; freezeMeleeDamage();
         deathAssert("melee-next-swing", predDam[u] == 80, "credited=" + predDam[u]);
         restorePredDead(); deathRemove(u);
         u = deathEnemy(); u.setPos(world.gg.X + world.gg.storona * 45, world.gg.Y);
         var kickCls:Class = ApplicationDomain.currentDomain.getDefinition("fe.weapon.WKick") as Class;
         var kick:Object = new kickCls(world.gg, "punch");
         kick.kick = false; kick.damage = 40; kick.t_attack = kick.rapid - 7;
         world.gg.currentWeapon = kick;
         kick.actions();
         var kickedHP:Number = u.hp;
         freezeMeleeDamage();
         deathAssert("inline-kick-not-double-counted", kickedHP < 10000 && predDam[u] == null && u.hp == kickedHP, "realLoss=" + (10000 - kickedHP) + " deferred=" + predDam[u]);
         world.gg.currentWeapon = savedWeapon;
         restorePredDead(); deathRemove(u);
      }
      private function runDeathProbe():void
      {
         world.onPause = true; world.testDam = true;
         var po:Object = world.pers;
         po.damPony = po.damZombie = po.damRobot = po.damInsect = po.damMonster = po.damAlicorn = 1;
         deathFormulaCase("unarmored", 0, 0, 0, 0, 0);
         deathFormulaCase("worn-already-in-projectile", 0, 0, 0, 0, 0, true);
         deathFormulaCase("laser-uses-magic-armor", 5, 70, 10, 10000, 0);
         deathFormulaCase("armor-break-on-this-hit", 0, 70, 0, 50, 0);
         deathFormulaCase("critical-after-armor", 0, 20, 0, 10000, 1);
         var u:Object = deathEnemy(); u.hp = 95;
         var b:Object = deathBullet(u);
         creditHit(b, 100);
         deathAssert("lethal-preview", predDead[u] == true, "credited=" + predDam[u] + " hp=" + u.hp + " sost=" + u.sost);
         restorePredDead(); deathRemove(u);
         u = deathEnemy(); b = deathBullet(u, 40);
         creditHit(b, 40); creditHit(b, 40);
         var once:Number = predDam[u];
         b.parr = [u]; // WClub.shoot starts a new swing by replacing parr.
         creditHit(b, 40);
         deathAssert("same-swing-not-duplicated", once > 0 && once <= 40, "once=" + once);
         deathAssert("second-swing-counted", Math.abs(Number(predDam[u]) - 80) < 0.001, "twoSwings=" + predDam[u]);
         restorePredDead(); deathRemove(u);
         u = deathEnemy(); u.disabled = false; u.hp = 95;
         b = deathBullet(u); b.parr = null;
         b.dx = 0; b.dy = 0; b.vel = 0; b.liv = 1;
         world.loc.addObj(b);
         slowStepWorld();
         deathAssert("removed-projectile-credited", predDead[u] == true && !b.in_chain && b.parr[0] === u,
            "inChain=" + b.in_chain + " contacts=" + (b.parr == null ? 0 : b.parr.length) + " targetMatch=" + (b.parr != null && b.parr[0] === u) + " raw=" + origDam[b] + " credited=" + predDam[u]);
         restorePredDead(); deathRemove(u);
         deathExtendedCases();
         log("[DEATH-TEST] SUMMARY " + (deathProbeFails == 0 ? "PASS" : "FAIL") + " checks=" + deathProbeChecks + " fails=" + deathProbeFails);
         NativeApplication.nativeApplication.exit(deathProbeFails == 0 ? 0 : 1);
      }
      private function stepDeathProbe():void
      {
         try
         {
            if (deathProbeTicks % 60 == 0) log("[DEATH-TEST] boot stage=" + deathProbeStage + " allStat=" + world.allStat + " mm=" + (world.mm != null ? world.mm.loaded : "null") + " land=" + (world.landData != null));
            if (++deathProbeTicks > 1800) throw new Error("boot timeout");
            if (deathProbeStage == 0 && world.mm != null && world.mm.loaded && world.landData != null)
            {
               world.mm.mainMenuOff(); world.newGame(-1, "DEATHTEST", {dif:2, propusk:true}); deathProbeStage = 1;
            }
            else if (deathProbeStage == 1 && world.allStat == 1 && world.gg != null && world.loc != null)
            {
               deathProbeStage = 2; runDeathProbe();
            }
         }
         catch(e:*) { log("[DEATH-TEST] ERROR " + e + " " + e.getStackTrace()); NativeApplication.nativeApplication.exit(2); }
      }
