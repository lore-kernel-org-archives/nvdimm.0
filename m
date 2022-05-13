Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063B47A;
	Fri, 13 May 2022 19:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CaSLwW+oyLeDXgO9x0n9GkutaCX9RJ8P3gxIZQp44gE=; b=156/ResqB83asUUdyV614QUH6W
	2gzvd8P+gUOmxTAe/ziA8p4/k+C8RA82mP5hod7Fi5KE5hAJIcKcMzjEZUhojIIauL3D60F7+5odR
	+ff/onQ1sc0BmF0qzMOiAYckPrelYZBH9ccs2Chz71/C1HF2DwXv5/DhWGCTqAzf/rn6mS1zTqOQI
	o3ksqEKoce0vSdtskQlULlKvhPlqj3tnQdx03dtCqUGqFvFIjlmgjnF+3cMnLLEkRYoNcsWesTOAz
	dSOnf3v9Cm7rk8dQmZ4CN+57EArrtrWsiwUIDYM9Afu4k3OdGsonOLTsR0MRrAH6kojiMhBjjOLyl
	at1eeXbw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1npb0i-00HLHD-9e; Fri, 13 May 2022 19:31:36 +0000
Date: Fri, 13 May 2022 12:31:36 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Klaus Jensen <its@irrelevant.dk>, Josef Bacik <jbacik@fb.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 02/15] cxl/core/hdm: Bail on endpoint init fail
Message-ID: <Yn6yGKmMZES0IQbw@bombadil.infradead.org>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-3-ben.widawsky@intel.com>
 <CAPcyv4hKGEy_0dMQWfJAVVsGu364NjfNeup7URb7ORUYLSZncw@mail.gmail.com>
 <CGME20220418163713uscas1p17b3b1b45c7d27e54e3ecb62eb8af2469@uscas1p1.samsung.com>
 <20220418163702.GA85141@bgt-140510-bm01>
 <20220512155014.bbyqvxqbqnm3pk2p@intel.com>
 <Yn1DiuqjYpklcEIT@bombadil.infradead.org>
 <20220513130909.0000595e@Huawei.com>
 <Yn51WhjsC1FDKNfS@bombadil.infradead.org>
 <CAPcyv4gwi1gr-_XTV9z5aZ-HJ=J5gDonQk0_M-_U9yYDqqi3PQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gwi1gr-_XTV9z5aZ-HJ=J5gDonQk0_M-_U9yYDqqi3PQ@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, May 13, 2022 at 12:14:51PM -0700, Dan Williams wrote:
> On Fri, May 13, 2022 at 8:12 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > But with CONFIG_FAIL_FUNCTION this means you don't have to open code
> > should_fail() calls, but instead for each routine you want to add a failure
> > injection support you'd just use ALLOW_ERROR_INJECTION() per call.
> 
> So cxl_test takes the opposite approach and tries not to pollute the
> production code with test instrumentation. All of the infrastructure
> to replace calls and inject mocked values is self contained in
> tools/testing/cxl/ where it builds replacement modules with test
> instrumentation. Otherwise its a maintenance burden, in my view, to
> read the error injection macros in the nominal code paths.

Is relying on just ALLOW_ERROR_INJECTION() per routine you'd want
to enable error injection for really too much to swallow?

  Luis
