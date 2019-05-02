Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A90221243BB0
 for <linux-nvdimm@lists.01.org>; Thu,  2 May 2019 15:29:36 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [v5 0/3] "Hotremove" persistent memory
Date: Thu, 2 May 2019 22:29:34 +0000
Message-ID: <9bf70d80718d014601361f07813b68e20b089201.camel@intel.com>
References: <20190502184337.20538-1-pasha.tatashin@soleen.com>
 <76dfe7943f2a0ceaca73f5fd23e944dfdc0309d1.camel@intel.com>
 <CA+CK2bA=E4zRFb0Qky=baOQi_LF4x4eu8KVdEkhPJo3wWr8dYQ@mail.gmail.com>
In-Reply-To: <CA+CK2bA=E4zRFb0Qky=baOQi_LF4x4eu8KVdEkhPJo3wWr8dYQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <93582F626602AA429B5A803F8F5CDACA@intel.com>
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
To: "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>
Cc: "sashal@kernel.org" <sashal@kernel.org>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "mhocko@suse.com" <mhocko@suse.com>, "david@redhat.com" <david@redhat.com>, "tiwai@suse.de" <tiwai@suse.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Huang, Ying  <ying.huang@intel.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jglisse@redhat.com" <jglisse@redhat.com>, "Wu, Fengguang  <fengguang.wu@intel.com>, baiyaowei@cmss.chinamobile.com" <baiyaowei@cmss.chinamobile.com>, "zwisler@kernel.org" <zwisler@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>, "bp@suse.de" <bp@suse.de>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2019-05-02 at 17:44 -0400, Pavel Tatashin wrote:

> > In running with these patches, and testing the offlining part, I ran
> > into the following lockdep below.
> > 
> > This is with just these three patches on top of -rc7.
> 
> Hi Verma,
> 
> Thank you for testing. I wonder if there is a command sequence that I
> could run to reproduce it?
> Also, could you please send your config and qemu arguments.
> 
Yes, here is the qemu config:

qemu-system-x86_64
	-machine accel=kvm
	-machine pc-i440fx-2.6,accel=kvm,usb=off,vmport=off,dump-guest-core=off,nvdimm
	-cpu Haswell-noTSX
	-m 12G,slots=3,maxmem=44G
	-realtime mlock=off
	-smp 8,sockets=2,cores=4,threads=1
	-numa node,nodeid=0,cpus=0-3,mem=6G
	-numa node,nodeid=1,cpus=4-7,mem=6G
	-numa node,nodeid=2
	-numa node,nodeid=3
	-drive file=/virt/fedora-test.qcow2,format=qcow2,if=none,id=drive-virtio-disk1
	-device virtio-blk-pci,scsi=off,bus=pci.0,addr=0x9,drive=drive-virtio-disk1,id=virtio-disk1,bootindex=1
	-object memory-backend-file,id=mem1,share,mem-path=/virt/nvdimm1,size=16G,align=128M
	-device nvdimm,memdev=mem1,id=nv1,label-size=2M,node=2
	-object memory-backend-file,id=mem2,share,mem-path=/virt/nvdimm2,size=16G,align=128M
	-device nvdimm,memdev=mem2,id=nv2,label-size=2M,node=3
	-serial stdio
	-display none

For the command list - I'm using WIP patches to ndctl/daxctl to add the
command I mentioned earlier. Using this command, I can reproduce the
lockdep issue. I thought I should be able to reproduce the issue by
onlining/offlining through sysfs directly too - something like:

   node="$(cat /sys/bus/dax/devices/dax0.0/target_node)"
   for mem in /sys/devices/system/node/node"$node"/memory*; do
     echo "offline" > $mem/state
   done

But with that I can't reproduce the problem.

I'll try to dig a bit deeper into what might be happening, the daxctl
modifications simply amount to doing the same thing as above in C, so
I'm not immediately sure what might be happening.

If you're interested, I can post the ndctl patches - maybe as an RFC -
to test with.

Thanks,
-Vishal



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
