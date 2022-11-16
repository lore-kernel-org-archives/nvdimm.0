Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DE23C3F
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 12:41:36 +0000 (UTC)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.west.internal (Postfix) with ESMTP id 516713200A20;
	Wed, 16 Nov 2022 07:41:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 16 Nov 2022 07:41:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm2; t=1668602494; x=1668688894; bh=xj
	3aKfxGwJy7lXbQUiNlCioBOeOFh5KNu2hZUUNyEXo=; b=GRQJGBVTIxLEtYCVRP
	zLh+nJtKtBpqKmugAoImt9AUTRJahXgIBi3tH2MIQvgllYyI9Pmsmi2aj9aGrJhx
	TGYWcixhHlE+rlMrphZbe5p3B38FtK80rNJ1FsgpC/+w8Lkm/srQ9MkGVsGIUEI4
	v74KqZzhdTxGb3uCT8IwR6A7Ox/fWEWSl/uBE6XuqpSGoEYxaqoL2S2pPMktdsT+
	JZpRKHl0PoXtjLAj5GRKXsBsGp12rgUgTkOu1+EXZSFyVDBISfs0EvHga2qKXKvL
	nKL9OdAcSsV7PloaflG8uVgstLQUeMCVCFvtwdcskp0xeC+u8GHi6xQx45Jt2tGZ
	G5sg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:sender:subject:subject:to:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1668602494; x=1668688894; bh=xj3aKfxGwJy7lXbQUiNlCioBOeOF
	h5KNu2hZUUNyEXo=; b=RSycFFAwA0Z9AXvR9/CDiwG0MxJwNDwZx3YAh3yT10vC
	1YwUnCrObKpHkyCXUbLK74n1Zzy0b0ZYbZJbSvAWITbM679bOrZ6pIPOmAIdjAp7
	YYKiYMgILh5WBuhqQTaESOxBajOkMYq+s53DzTzgLiKZl6vs0bP8O4zBbVXfyfQV
	VSuk/CiRb+kpdTOgPwMDOW3cY//JmvGidoBwj1b2ApZDjLxJXA1RE/eriMHgd6zm
	3W5xvyMJWshwXQ5yXwO7VNmfmGMyzmpohSRaaC7+jdBl6SQDlaawMI092X77hf/M
	OrwUK6HApThQiC31HGp4dfpMug0UtnG/Pw/S9+3njQ==
X-ME-Sender: <xms:fdp0Yx76idkpSJK5pY3Y3cYMASOskhIuyCJ_BM96aSKRAxmaosANkg>
    <xme:fdp0Y-6OFHZQmYjld5z4TEIup7Cs3XjAwpH_PIckDKNKNPSB2kiMEMTD_9Dp3Un5H
    Ef4635Gr8KXdbRf4Jg>
X-ME-Received: <xmr:fdp0Y4cH892ZmuUG2RYErGWetDXUk09xYaz2inWkUFAIoFEVSE5JaGQub2OIM5p8bHQ3Ww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrgeeigdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttddttddttddvnecuhfhrohhmpedfmfhirhhi
    lhhlucetrdcuufhhuhhtvghmohhvfdcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrg
    hmvgeqnecuggftrfgrthhtvghrnhephfeigefhtdefhedtfedthefghedutddvueehtedt
    tdehjeeukeejgeeuiedvkedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgv
X-ME-Proxy: <xmx:fdp0Y6LqlCDxwAHVKTlJgEB9RsMBqvgrFf0Shdb-5UNwJRTySY9orQ>
    <xmx:fdp0Y1I30a-yxS4XcObHKA87sycPezdgQRvHXQZHM-lqfy4cxKRJ1A>
    <xmx:fdp0YzzWRnDLMjnJYMW7ZzMH3kesULzUrTbvo9GzOIMFD8zf76smIg>
    <xmx:ftp0Y98iApG9O-v6-7afanDkJX_SaQKwhhtzGi26OMT6P5kRi1umiQ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Nov 2022 07:41:33 -0500 (EST)
Received: by box.shutemov.name (Postfix, from userid 1000)
	id E64DE104CEC; Wed, 16 Nov 2022 15:41:30 +0300 (+03)
Date: Wed, 16 Nov 2022 15:41:30 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, liushixin2@huawei.com,
	"Rafael J . Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 1/2] ACPI: HMAT: remove unnecessary variable
 initialization
Message-ID: <20221116124130.wqa6ywjs5x6gkg45@box.shutemov.name>
References: <20221116075736.1909690-1-vishal.l.verma@intel.com>
 <20221116075736.1909690-2-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116075736.1909690-2-vishal.l.verma@intel.com>

On Wed, Nov 16, 2022 at 12:57:35AM -0700, Vishal Verma wrote:
> In hmat_register_target_initiators(), the variable 'best' gets
> initialized in the outer per-locality-type for loop. The initialization
> just before setting up 'Access 1' targets was unnecessary. Remove it.
> 
> Cc: Rafael J. Wysocki <rafael@kernel.org>
> Cc: Liu Shixin <liushixin2@huawei.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>


-- 
  Kiryl Shutsemau / Kirill A. Shutemov
