Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB722F26
	for <nvdimm@lists.linux.dev>; Tue, 16 Aug 2022 09:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rFcsh5EaXMjyQvBz6Px9JuV8hMB5E551U26Ntc3NwIA=; b=GJchraaCp4Klmfi3ZVHxYa9oRu
	b4agUH2uWZUTGNSV7SBi9fApi/iBoiVncfCPPHT8N/smFMxxCHdxc2qJL0NAbVmP78DMRliIAybve
	8oFbik7+x32aIcWla7kp5/4bFOB86cScaS8UEumAsr9W+yElrNSfNFCf5pwnIHawItattmLVPtF9Q
	nfyPrB4EWP+fCEnqnTrsY0Kxaw8X+ypYlJQyIHjy3clqn11hb/eScLGNIiJg3D3XNKZAnZcpbMVi5
	Sl+UKBGD4B3ss+b8KxyJ1OrSsUMsYYCNDfajqcuNNHcv/f0zui+onWZGz0gCItg5Kw8bJdifIBHG8
	+E+BKhcw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1oNsRn-002ufq-7J; Tue, 16 Aug 2022 09:01:15 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6E714980083; Tue, 16 Aug 2022 11:01:14 +0200 (CEST)
Date: Tue, 16 Aug 2022 11:01:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	bwidawsk@kernel.org, ira.weiny@intel.com, vishal.l.verma@intel.com,
	alison.schofield@intel.com, a.manzanares@samsung.com,
	linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org, bp@alien8.de, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/cacheflush: Introduce flush_all_caches()
Message-ID: <Yvtc2u1J/qip8za9@worktop.programming.kicks-ass.net>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <165791937063.2491387.15277418618265930924.stgit@djiang5-desk3.ch.intel.com>
 <20220718053039.5whjdcxynukildlo@offworld>
 <4bedc81d-62fa-7091-029e-a2e56b4f8f7a@intel.com>
 <20220803183729.00002183@huawei.com>
 <9f3705e1-de21-0f3c-12af-fd011b6d613d@intel.com>
 <YvO8pP7NUOdH17MM@FVFF77S0Q05N>
 <62f40fba338af_3ce6829466@dwillia2-xfh.jf.intel.com.notmuch>
 <20220815160706.tqd42dv24tgb7x7y@offworld>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815160706.tqd42dv24tgb7x7y@offworld>

On Mon, Aug 15, 2022 at 09:07:06AM -0700, Davidlohr Bueso wrote:
> diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
> index b192d917a6d0..ce2ec9556093 100644
> --- a/arch/x86/include/asm/cacheflush.h
> +++ b/arch/x86/include/asm/cacheflush.h
> @@ -10,4 +10,7 @@
> 
>  void clflush_cache_range(void *addr, unsigned int size);
> 
> +#define flush_all_caches() \
> +	do { wbinvd_on_all_cpus(); } while(0)
> +

This is horrific... we've done our utmost best to remove all WBINVD
usage and here you're adding it back in the most horrible form possible
?!?

Please don't do this, do *NOT* use WBINVD.
