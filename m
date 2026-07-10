Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C19E37AA96
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 18:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783709964; cv=none; b=BWN5tPe93yS8ZlexLXDtEiScitUFbkrLjJNorFQXwHxuG1435RubWC+L0df+g/jO7hune++odna++EmmjGE6+3aUOvk6pKUV1Qbh/x/l3+bhVR0XwuurgPRe8vEctyE2NOt4skZXgETWOSBucxG0uBwLS7/OGH7kovX8cTvDDzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783709964; c=relaxed/simple;
	bh=L1PtE+Fge/ce+F2DBwYJ3SZFAaV5kA0gEoEabNlaIYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TLZsgt/zMAB+gU975MDbc/I/4U1EQPrLsThKplrzS+qvvHPVf1PiXxQ/JIry87KapD8AfaKBn1Oo/voK+XpxhRW3N8ILrqyoDDVLBOGJyNmQ1ckBgjztAVteXlpICYutJDImiCy8UEJOULttKb9SooGc/zHDk2aFzEeYGinC34Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=pN0u4D7G; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="pN0u4D7G"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51bfbe05683so7570161cf.2
        for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 11:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783709962; x=1784314762; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=74B4rm3uR5k1lRSPUh5wFwkcdLxEy4GniWsMlOdHPw0=;
        b=pN0u4D7GXSid4sgJShtz/SNM4gHv2iv5nA1MYqnWFEeahegktICLV8Hw5SoTWxraLS
         a7IpfnaaAVlUPvr3fkpMkprg6ZHLb7WVWDDBcIqrfJkQPcAMz/s1aaj/EWohpZ1IhAON
         W2YzKNj0ZLOBlpfgnIuMw17SJKGowLkc7NthfVqZxJcdHLrFclVEMB1kePiaH3iAwiE1
         4+J94X875NiZJtzbYMW2lKin7OyhPv/5VCy3f3GCJMup3DcQ2sfdndSvg27djN1ZOPBr
         vNtha12La9avYOrtzP+7DLC2dvl9puFYmtC7YqcQCIQiDQjilzpFhw/44omTtoPOipZv
         Nlxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783709962; x=1784314762;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=74B4rm3uR5k1lRSPUh5wFwkcdLxEy4GniWsMlOdHPw0=;
        b=MgctYgmjhUZb/u4ZymuEmr1zjf1abOxFw7w9c+SkXHXNP2HwnJRYSvtE/rlU7Q9nlU
         WtH2XAlmEJZ40HatDgoO2IKyCrSC6hv/sxOOIRoU/OqEQdddvVgJXAXzaT1mxqpEmnbh
         NBDPCDJDRF5jjhs0atiK2OMS1ZpjenaAlcSTfRO7GMO6KcAXiRpeRZQDDNoT+rAK1Q1b
         P7zf9F0QrPj6tg9c0uUHLqbYenhvCn0I+48jt/myGtBNRhz6py11dqsd2pzCPP6xyfSL
         wXW3mj1GEIi2oiPxuOudRl40U7uOTeigyx5fCIwl8zoythyc/Yr/0cI9gBovGjl33pBE
         DRUA==
X-Forwarded-Encrypted: i=1; AHgh+RrQMn/VCExPOwXxOg1sD3fa8jkwS4NyehDSFypdyb6QqgxPlfUYH8NjenkSCEgDKRdpwRDBJLk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJQDtmzq0yK2gEc6SQDy61Vd09NVXXruRDWYan4juCYJVd6wF1
	qDMc9oZCTWCB7m+CO52LH/OrOwJYhaXwnJfTxt6VCq7b9w8GI+SrsSPCf8HVSQrbRkM=
X-Gm-Gg: AfdE7cmjbQxCQ0AfjYUsiibzu0Kg9XSp7mfCEFXWDS7Xt8rugI8furLIKXA8Sy6Q7xL
	ikVlVbzjglZepcBhxPLqI1DXbU+/DqAWs9LCcvck44XNOaK7Gv5cYB6bgeXqn8MDL3r/gvJ3CZ9
	75DbjgXoNpEJl2wOaG9IHJM14v6rU/7FbcjdrAFY08lYx+1EmukQo5yPlzAns0RaMxRXlbxCLGr
	F+8gr9JzFagr5ao15eimXHXHFV3xqMRtNH4hfLBZS3NdiPvNzD2QDxbMNXZPIkIR1IxJOp7XNxf
	DuWNPxfiwU2gF4Mpn+Owlvl/3WjN+anvd1eAT7BMl3vTN4edfCAek97WcLvptgdlqTqSnTEzTor
	7gop1mKk3n363qostejwPlDpfwpDbEPmdc0zGBfcy2SFn0al/0MZdwcd7+5o+GYiHABn++MncZ6
	IG9t5ZKDN6+oEsjkvrLViNTax+RGF3aGY6JfFUzNOTwDTezLOz26a5kPwLRcxNEZxhTyic
X-Received: by 2002:a05:622a:1b17:b0:51c:2101:ef with SMTP id d75a77b69052e-51cbf156814mr1787851cf.19.1783709961653;
        Fri, 10 Jul 2026 11:59:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51cb884e0cfsm12321961cf.29.2026.07.10.11.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 11:59:21 -0700 (PDT)
Date: Fri, 10 Jul 2026 14:59:16 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 24/30] mm/vma: update vma_shrink() to not pass
 unnecessary pgoff parameter
Message-ID: <alFBBGN6a30A3bQ9@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <6dd744d57d778f94d2fef8fd623d7c4ed8010d93.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dd744d57d778f94d2fef8fd623d7c4ed8010d93.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:35PM +0100, Lorenzo Stoakes wrote:
> vma_shrink() does not need to adjust vma->vm_pgoff, we were passing this
> parameter solely to satisfy vma_set_range()'s requirement for pgoff being
> specified.
> 
> Since vma_set_range() is now isolated to vma.c, we can simply introduce
> __vma_set_range() which sets only vma->vm_[start, end], and invoke this
> instead, removing pgoff from vma_shrink() altogether.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

