Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE40B3D6A;
	Fri, 13 May 2022 15:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Cd9PH8vSCSi14Ueao/akanyMbAD6AVC4Y7QV2h7oS80=; b=kAGcFFrNoC36SXHALR7HQRLkUM
	HQKebc+y1YO06oK72S/gThoznUeJWRsDU9tTu7ARMGf0kk7gafeK2SraClvMYcq7fuI3jbKIWrzg/
	pJPwU3nIWF0BqvCfmNGfIWuFloaOsAR6N1c1+aAt/zhOe1igsTvNbOa2gzyO1Qe0vAasqsFvIA4dS
	HO5WCL25lFbOE76rqE3VfKaq/OJBGFt/gyy9mfqQ4nygM+q/sDKL0v0jwrBnpKvEQRkUKcbp9210N
	hV8fS9h2AtPXKqXSHEeq/hmHeK63b9PHIB/xYVrj1RgFebRAW7XYtnE5kaoW/SezlbF4yzBBsDog/
	C2MBqLHA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1npWxu-00Gb0k-87; Fri, 13 May 2022 15:12:26 +0000
Date: Fri, 13 May 2022 08:12:26 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Klaus Jensen <its@irrelevant.dk>,
	Josef Bacik <jbacik@fb.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 02/15] cxl/core/hdm: Bail on endpoint init fail
Message-ID: <Yn51WhjsC1FDKNfS@bombadil.infradead.org>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-3-ben.widawsky@intel.com>
 <CAPcyv4hKGEy_0dMQWfJAVVsGu364NjfNeup7URb7ORUYLSZncw@mail.gmail.com>
 <CGME20220418163713uscas1p17b3b1b45c7d27e54e3ecb62eb8af2469@uscas1p1.samsung.com>
 <20220418163702.GA85141@bgt-140510-bm01>
 <20220512155014.bbyqvxqbqnm3pk2p@intel.com>
 <Yn1DiuqjYpklcEIT@bombadil.infradead.org>
 <20220513130909.0000595e@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513130909.0000595e@Huawei.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, May 13, 2022 at 01:09:09PM +0100, Jonathan Cameron wrote:
> On Thu, 12 May 2022 10:27:38 -0700
> Luis Chamberlain <mcgrof@kernel.org> wrote:
> 
> > On Thu, May 12, 2022 at 08:50:14AM -0700, Ben Widawsky wrote:
> > > On 22-04-18 16:37:12, Adam Manzanares wrote:  
> > > > On Wed, Apr 13, 2022 at 02:31:42PM -0700, Dan Williams wrote:  
> > > > > On Wed, Apr 13, 2022 at 11:38 AM Ben Widawsky <ben.widawsky@intel.com> wrote:  
> > > > > >
> > > > > > Endpoint decoder enumeration is the only way in which we can determine
> > > > > > Device Physical Address (DPA) -> Host Physical Address (HPA) mappings.
> > > > > > Information is obtained only when the register state can be read
> > > > > > sequentially. If when enumerating the decoders a failure occurs, all
> > > > > > other decoders must also fail since the decoders can no longer be
> > > > > > accurately managed (unless it's the last decoder in which case it can
> > > > > > still work).  
> > > > > 
> > > > > I think this should be expanded to fail if any decoder fails to
> > > > > allocate anywhere in the topology otherwise it leaves a mess for
> > > > > future address translation code to work through cases where decoder
> > > > > information is missing.
> > > > > 
> > > > > The current approach is based around the current expectation that
> > > > > nothing is enumerating pre-existing regions, and nothing is performing
> > > > > address translation.  
> > > > 
> > > > Does the qemu support currently allow testing of this patch? If so, it would 
> > > > be good to reference qemu configurations. Any other alternatives would be 
> > > > welcome as well. 
> > > > 
> > > > +Luis on cc.
> > > >   
> > > 
> > > No. This type of error injection would be cool to have, but I'm not sure of a
> > > good way to support that in a scalable way. Maybe Jonathan has some ideas?  
> > 
> > In case it helps on the Linux front the least intrusive way is to use
> > ALLOW_ERROR_INJECTION(). It's what I hope we'll slowly strive for on
> > the block layer and filesystems slowly. That incurs one macro call per error
> > routine you want to allow error injection on.
> > 
> > Then you use debugfs to dynamically enable / disable the error
> > injection / rate etc.
> > 
> > So I think this begs the question, what error injection mechanisms
> > exist for qemu and would new functionality be welcomed?
> 
> So what paths can actually cause this to fail?

If you are asking about adopting something like the failmalloc
should_fail() strategy in qemu, you'd essentially open code a call to
a should_fail() and in it pass the arguments you want from your
own call down. If you want to ignore size you can just pass 0
for instance.

> Looking at the upstream
> code in init_hdm_decoder() looks like there are only a few things that
> are checked. 

If you mean in Linux, you would open code a should_fail()
specific to the area as in this commit old commit example, and
adding a respective kconfig entry for it:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8a8b6502fb669c3a0638a08955442814cedc86b1

Eech of these knobs then get its own probability, times, and space
debugfs entries which let the routine should_fail() fail when the
parameters set meet the criteria set by debugfs.

There are ways to make this much more scalable though, but I had not
seen many efforts to do so. I did start such an approach using debugfs
specific to *one* kconfig entry, for instance see this block layer proposed
change, which would in turn enable tons of different ways to enable failing
if CONFIG_FAIL_ADD_DISK would be used:

https://lore.kernel.org/linux-block/20210512064629.13899-9-mcgrof@kernel.org/

However, at the recent discussion at LSFMM for this we decided instead
to just sprinkle ALLOW_ERROR_INJECTION() after each routine. Otherwise
you are open coding tons of new "should_fail()" calls in your runtime
path and that can make it hard to review patches and is just a lot of
noise in code.

But with CONFIG_FAIL_FUNCTION this means you don't have to open code
should_fail() calls, but instead for each routine you want to add a failure
injection support you'd just use ALLOW_ERROR_INJECTION() per call.

Read Documentation/fault-injection/fault-injection.rst on
fail_function/injectable and fail_function/<function-name>/retval,
so we could do for instance, to avoid a namespace clash I just
added the cxl_ prefix:

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 0e89a7a932d4..2aff3bace698 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -149,8 +149,8 @@ static int to_interleave_ways(u32 ctrl)
 	}
 }
 
-static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
-			    int *target_map, void __iomem *hdm, int which)
+static int cxl_init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
+				int *target_map, void __iomem *hdm, int which)
 {
 	u64 size, base;
 	u32 ctrl;
@@ -207,6 +207,7 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 
 	return 0;
 }
+ALLOW_ERROR_INJECTION(cxl_init_hdm_decoder, ERRNO);
 
 /**
  * devm_cxl_enumerate_decoders - add decoder objects per HDM register set
@@ -251,8 +252,8 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
 			return PTR_ERR(cxld);
 		}
 
-		rc = init_hdm_decoder(port, cxld, target_map,
-				      cxlhdm->regs.hdm_decoder, i);
+		rc = cxl_init_hdm_decoder(port, cxld, target_map,
+					  cxlhdm->regs.hdm_decoder, i);
 		if (rc) {
 			put_device(&cxld->dev);
 			failed++;

This lets's us then modprobe the cxl modules and then:

root@kdevops-dev ~ # grep ^cxl /sys/kernel/debug/fail_function/injectable 
cxl_init_hdm_decoder [cxl_core] ERRNO

echo cxl_init_hdm_decoder > /sys/kernel/debug/fail_function/cxl_init_hdm_decoder/
printf %#x -6 > /sys/kernel/debug/fail_function/cxl_init_hdm_decoder/retval

Now this routine will return -ENXIO (-6) when called but I think
you still need to set the probability for this to not be 0:

cat /sys/kernel/debug/fail_function/probability 
0

In the world where ALLOW_ERROR_INJECTION() is not used we'd get one of
each of the probability, space and times for each new failure injection
function.

> base or size being all fs or interleave ways not being a value the
> kernel understands.

I think that if you want to make use of variable failures depending on
input data you might as well open code your own should_fail() calls
as I did in the above referenced block layer patches for add_disk with
your own kconfig entry.

ALLOW_ERROR_INJECTION() seems to be useful if you are OK to do simple
failures based on a return code and probably a probablity / times
values (times means that if you say 2 it will fail ever 2 calls).

There are odd uses of ALLOW_ERROR_INJECTION() but I can't say I'm a fan
of: drivers/platform/surface/aggregator/ssh_packet_layer.c

> For all fs, I'm not sure how we'd get that value?

You'd echo the return value you want to fake a failure for into the
debugfs retval. If you open code your own should_fail() you can use
size, space, probability in whatever you see fit.

> For interleave ways:
> Our current verification of writes to these registers in QEMU is very
> limited I think you can currently push in an invalid value. We are only
> masking writes, not checking for mid range values that don't exist.
> However, that's something I'll be looking to restrict soon as we add
> more input verification so I wouldn't rely on it.
> 
> I'm not aware of anything general affecting QEMU devices emulation.
> I've hacked cases in as temporary tests but not sure
> we'd want to carry something specific for this one.

I'd imagine as in any subsystem finding the few key areas you *do* want
test coverage for failure injection will be a nice fun next step. It is
understandable if init_hdm_decoder() is not it.

  Luis
