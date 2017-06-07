Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 51E2C2095CC55
 for <linux-nvdimm@lists.01.org>; Tue,  6 Jun 2017 17:32:37 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id E2D21AC00D6
 for <linux-nvdimm@lists.01.org>; Wed,  7 Jun 2017 09:33:37 +0900 (JST)
Date: Wed, 07 Jun 2017 09:33:31 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: Panic when make check for ndctl
In-Reply-To: <CAPcyv4gaPFQhkdRYPo3UDQRWqPw4W31P9pazeHqUkHKpBU9WCQ@mail.gmail.com>
References: <20170606145109.7B82.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4gaPFQhkdRYPo3UDQRWqPw4W31P9pazeHqUkHKpBU9WCQ@mail.gmail.com>
Message-Id: <20170607093328.BE75.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> > Hmmm, though I made Fedora 25 environment, this panic still occurs...
> > I'll attach syslog and .config again.
> >
> >
> [..]
> > [  117.804948] general protection fault: 0000 [#1] SMP
> [..]
> > [  117.820866] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [..]
> > [  117.843262] Call Trace:
> > [  117.843985]  release_nodes+0x76/0x260
> > [  117.845062]  devres_release_all+0x3c/0x50
> > [  117.846225]  device_release_driver_internal+0x159/0x200
> > [  117.847748]  device_release_driver+0x12/0x20
> > [  117.849029]  bus_remove_device+0xfd/0x170
> > [  117.850192]  device_del+0x1e8/0x330
> > [  117.851284]  platform_device_del+0x28/0x90
> > [  117.852485]  platform_device_unregister+0x12/0x30
> > [  117.853846]  nfit_test_exit+0x2a/0x93b [nfit_test]
> > [  117.855219]  SyS_delete_module+0x171/0x250
> > [  117.856403]  entry_SYSCALL_64_fastpath+0x1a/0xa5
> 
> Can you also attach the qemu-kvm command line you are using?
> 
>     ps aux | grep qemu

Sure!

---
$ ps auxw |grep qemu |grep goto-fedora
qemu     45082  2.1 16.9 17408108 5547508 ?    Sl   Jun06  30:37 /usr/libexec/qemu-kvm -name goto-fedora -S -machine pc-i440fx-rhel7.0.0,accel=kvm,usb=off -cpu Nehalem -m 16384 -realtime mlock=off -smp 12,sockets=12,cores=1,threads=1 -uuid b9802ae7-404e-453b-8998-24dfc81567f2 -nographic -no-user-config -nodefaults -chardev socket,id=charmonitor,path=/var/lib/libvirt/qemu/domain-26-goto-fedora/monitor.sock,server,nowait -mon chardev=charmonitor,id=monitor,mode=control -rtc base=utc,driftfix=slew -global kvm-pit.lost_tick_policy=discard -no-hpet -no-shutdown -global PIIX4_PM.disable_s3=1 -global PIIX4_PM.disable_s4=1 -boot strict=on -device ich9-usb-ehci1,id=usb,bus=pci.0,addr=0x5.0x7 -device ich9-usb-uhci1,masterbus=usb.0,firstport=0,bus=pci.0,multifunction=on,addr=0x5 -device ich9-usb-uhci2,masterbus=usb.0,firstport=2,bus=pci.0,addr=0x5.0x1 -device ich9-usb-uhci3,masterbus=usb.0,firstport=4,bus=pci.0,addr=0x5.0x2 -device virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x4 -drive f
 ile=/var/lib/libvirt/images/goto-fedora.img,format=qcow2,if=none,id=drive-virtio-disk0 -device virtio-blk-pci,scsi=off,bus=pci.0,addr=0x6,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=1 -drive if=none,id=drive-ide0-0-0,readonly=on -device ide-cd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0 -netdev tap,fd=26,id=hostnet0,vhost=on,vhostfd=28 -device virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:fa:94:a9,bus=pci.0,addr=0x3 -chardev pty,id=charserial0 -device isa-serial,chardev=charserial0,id=serial0 -chardev socket,id=charchannel0,path=/var/lib/libvirt/qemu/channel/target/domain-26-goto-fedora/org.qemu.guest_agent.0,server,nowait -device virtserialport,bus=virtio-serial0.0,nr=1,chardev=charchannel0,id=channel0,name=org.qemu.guest_agent.0 -device usb-tablet,id=input0,bus=usb.0,port=1 -device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x7 -msg timestamp=on
----

---
Yasunori Goto

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
