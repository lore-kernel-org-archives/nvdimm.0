Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F520257A
	for <nvdimm@lists.linux.dev>; Thu, 27 Apr 2023 11:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983F9C433D2;
	Thu, 27 Apr 2023 11:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682595544;
	bh=4rgucKIZ0mWJYXTLMoK/Iw2ESWS1PyrVYY7PH8TXaCk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aPOd/pfc++x0Pjtup6GWjQbCFu66wPW4KqFu8J/koiPblLLO0ZoZF/7QhgWpUcNKP
	 0jCMkQ01z7p3rCYIwH92lYVHEGR9KtJ6va6XsX9yBOMrvp58cuVTKoDcrrZ6uXytD4
	 b8CZ8lgyrbtKbRJk9EzzgqfflXNKxCCGCOXY3iB8=
Date: Thu, 27 Apr 2023 13:39:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: x86@kernel.org, nvdimm@lists.linux.dev, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, y-goto@fujitsu.com,
	yangx.jy@fujitsu.com, ruansy.fnst@fujitsu.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Takashi Iwai <tiwai@suse.de>, Baoquan He <bhe@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Ira Weiny <ira.weiny@intel.com>,
	Raul E Rangel <rrangel@chromium.org>,
	Colin Foster <colin.foster@in-advantage.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH v2 3/3] resource, crash: Make kexec_file_load support
 pmem
Message-ID: <2023042726-railroad-detonator-cc0d@gregkh>
References: <20230427101838.12267-1-lizhijian@fujitsu.com>
 <20230427101838.12267-4-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427101838.12267-4-lizhijian@fujitsu.com>

On Thu, Apr 27, 2023 at 06:18:34PM +0800, Li Zhijian wrote:
> It does:
> 1. Add pmem region into PT_LOADs of vmcore
> 2. Mark pmem region's p_flags as PF_DEV

I'm sorry, but I can not parse this changelog.

Please take a look at the kernel documentation for how to write a good
changelog message so that we can properly review the change you wish to
have accepted.

thanks,

greg k-h
