Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147B229CA;
	Fri, 10 Dec 2021 19:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817A2C00446;
	Fri, 10 Dec 2021 19:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1639165128;
	bh=XUCqC2tL/H4Bo3w8QxARxKxRgTDRTsj/MFHask4xLLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jfK5s+NNG8Y60b5T4+zIaE7BKuIbrmsIMp/vRjw2Gi6zP0tmk+WFCPCDk9m5zeRAK
	 KYfxsWKZeOlZ30JaWPXiu4SIo668hdFQgNgKlQuKm5S7UUPc35ZeixjnqwqqIZNnTa
	 zMpkHc15QsB5WE9SOdkWQIIspfatFmLHh4zSeWljcyc5z5TfledHuJVDQvumrc4MqB
	 aiGTl7/x7hAHBsqVVXU1Tt5Ko0zd7wQO2rfz5aSxo2J8HrsJ9SrX8oZ9nR6O6WoPfO
	 qUp9Pt40otCk0RRPdQvWAX7EX+DZj2U3Ux9l0HxHJhOdcOupAgrrVVPJlViKY8KJCl
	 cV/6kcq6OB7Mw==
Date: Fri, 10 Dec 2021 12:38:43 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Ben Widawsky <ben.widawsky@intel.com>, nvdimm@lists.linux.dev,
	Jonathan.Cameron@huawei.com, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com,
	llvm@lists.linux.dev
Subject: Re: [PATCH v6 21/21] cxl/core: Split decoder setup into alloc + add
Message-ID: <YbOswyDRX1SEtE8C@archlinux-ax161>
References: <163164780319.2831662.7853294454760344393.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163225205828.3038145.6831131648369404859.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <163225205828.3038145.6831131648369404859.stgit@dwillia2-desk3.amr.corp.intel.com>

Hi Dan,

On Tue, Sep 21, 2021 at 12:22:16PM -0700, Dan Williams wrote:
> The kbuild robot reports:
> 
>     drivers/cxl/core/bus.c:516:1: warning: stack frame size (1032) exceeds
>     limit (1024) in function 'devm_cxl_add_decoder'
> 
> It is also the case the devm_cxl_add_decoder() is unwieldy to use for
> all the different decoder types. Fix the stack usage by splitting the
> creation into alloc and add steps. This also allows for context
> specific construction before adding.
> 
> With the split the caller is responsible for registering a devm callback
> to trigger device_unregister() for the decoder rather than it being
> implicit in the decoder registration. I.e. the routine that calls alloc
> is responsible for calling put_device() if the "add" operation fails.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Apologies for not noticing this sooner, given that I was on the thread.

This patch as commit 48667f676189 ("cxl/core: Split decoder setup into
alloc + add") in mainline does not fully resolve the stack frame
warning. I still see an error with both GCC 11 and LLVM 12 with
allmodconfig minus CONFIG_KASAN.

GCC 11:

drivers/cxl/core/bus.c: In function ‘cxl_decoder_alloc’:
drivers/cxl/core/bus.c:523:1: error: the frame size of 1032 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
  523 | }
      | ^
cc1: all warnings being treated as errors

LLVM 12:

drivers/cxl/core/bus.c:486:21: error: stack frame size of 1056 bytes in function 'cxl_decoder_alloc' [-Werror,-Wframe-larger-than=]
struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets)
                    ^
1 error generated.

This is due to the cxld_const_init structure, which is allocated on the
stack, presumably due to the "const" change requested in v5 that was
applied to v6. Undoing that resolves the warning for me with both
compilers. I am not sure if you have a better idea for how to resolve
that.

diff --git a/drivers/cxl/core/bus.c b/drivers/cxl/core/bus.c
index ebd061d03950..46ce58376580 100644
--- a/drivers/cxl/core/bus.c
+++ b/drivers/cxl/core/bus.c
@@ -485,9 +485,7 @@ static int decoder_populate_targets(struct cxl_decoder *cxld,
 
 struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets)
 {
-	struct cxl_decoder *cxld, cxld_const_init = {
-		.nr_targets = nr_targets,
-	};
+	struct cxl_decoder *cxld;
 	struct device *dev;
 	int rc = 0;
 
@@ -497,13 +495,13 @@ struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets)
 	cxld = kzalloc(struct_size(cxld, target, nr_targets), GFP_KERNEL);
 	if (!cxld)
 		return ERR_PTR(-ENOMEM);
-	memcpy(cxld, &cxld_const_init, sizeof(cxld_const_init));
 
 	rc = ida_alloc(&port->decoder_ida, GFP_KERNEL);
 	if (rc < 0)
 		goto err;
 
 	cxld->id = rc;
+	cxld->nr_targets = nr_targets;
 	dev = &cxld->dev;
 	device_initialize(dev);
 	device_set_pm_not_required(dev);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 3af704e9b448..7c2b51746e31 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -191,7 +191,7 @@ struct cxl_decoder {
 	int interleave_granularity;
 	enum cxl_decoder_type target_type;
 	unsigned long flags;
-	const int nr_targets;
+	int nr_targets;
 	struct cxl_dport *target[];
 };
 
