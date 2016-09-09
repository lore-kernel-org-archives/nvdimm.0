Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Fri, 9 Sep 2016 10:03:27 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: DAX can not work on virtual nvdimm device
Message-ID: <20160909140327.r2j64s5xdaxnnxhx@thunk.org>
References: <20160819183047.GA7216@linux.intel.com>
 <600ac51c-0f61-6e53-9bfa-669c85494d1f@linux.intel.com>
 <20160829193014.GB16738@linux.intel.com>
 <61d5c470-a8bf-86d5-d1fe-b4b577a85967@linux.intel.com>
 <CAPcyv4hrFSxNcmmVLVZT4fK3+hspPCDKW0rVBj1=3GkJRgZ29Q@mail.gmail.com>
 <25098f37-53f7-6d5d-0b1a-8469bab51a9f@linux.intel.com>
 <20160902025738.GA26108@linux.intel.com>
 <20160906150620.GJ28922@quack2.suse.cz>
 <20160908204708.GA15167@linux.intel.com>
 <20160909091925.GF22777@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160909091925.GF22777@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Yumei Huang <yuhuang@redhat.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, KVM <kvm@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, LKML <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 09, 2016 at 11:19:25AM +0200, Jan Kara wrote:
> > > > > 1. make the guest kernel based on your tree, the top commit is
> > > > >    10d7902fa0e82b (dax: unmap/truncate on device shutdown) and
> > > > >    the config file can be found in this thread.

What git tree is 10d7902fa0e82b from?

> Hum, nothing unusual in there. I've tried reproducing on a local SLE11 SP3
> machine (which is from about the same time) but everything works as
> expected there. Shrug...

I just tried reproducing it via "gce-xfstests --pmem-device shell"
with a downgraded e2fsprogs to stock upstream 1.42.12, and I can't
reproduce it with the ext4.git tree.  I'm not sure whether the git
commit is critical, though.  Is this a regression that was working
before?

Or it's possible that Red Hat did something weird with the CentOS 6
e2fsprogs....

					- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
