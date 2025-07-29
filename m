Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205A62698BF
	for <nvdimm@lists.linux.dev>; Tue, 29 Jul 2025 07:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753775618; cv=none; b=hNUfAYg5+MGHDjnejSNXDh0bDCe2eOp6i0wE5YyKLxx7K9gWwsK0QY7k+d4tMFbtVhVH+9jNioborTyrT7A110AtWJzaMB4lPfUDWFcmQ03z25NNUFKZesPrnaO9vh3t2FvaSvXksmxF1bhYG/teNBa8+wWH14dTC3i9mlqGgII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753775618; c=relaxed/simple;
	bh=aes4PlrG7u8ZTpHznRKhnbdzYLwksa7kjjCc3G53RK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E4VKdrrBfLXw9r/j7bILheRNfqDpZk7oF0Fu7OkruHWYniUGWB6NO+/xKDmxBpA9/MsOmlNiosfuqAiDe2BMqqrRKuSBGscLdclBTXJSN+FvVUDr8Krb/larzNDHvOLLCJ9FmxsHLkfX/Aks/JjAsCK5ouv1x+80fYu4+JFyUMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b0xomXec; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b0xomXec"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61557997574so2074889a12.3
        for <nvdimm@lists.linux.dev>; Tue, 29 Jul 2025 00:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753775614; x=1754380414; darn=lists.linux.dev;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xsVo12V6n1cHZPjfQGvjTgS28eByrDkHggKW6JJVbsg=;
        b=b0xomXecd98jYlJi8muZzUDRW55jshBzpksH0MwwnwiNmMQn9oRWODPPXOXL7oMnvW
         kepFzC43ePjS27Jcav4j3M7pnR0HgRtQSZA+OE0A7ydb/+xwLKEKEZn7IuSFi3QZag4z
         L2z6q6KQLocLD+70ns05lTkqcAd0hDAjC5oOZNhdzjIXaaC0LkV2mN7cmxoZ3rAkbcEj
         TI2SXFuoySqLS0nJH6YjqaVrBzHO0Hu+R09rK/PQQL8UL7Abgyz2NKWjjPh/R1V+2lak
         MDFIh7c86ekxGXOAuVbWTvjtk/bLlXI48j8AYq/K0LaNTPfe4Wt4xdAlSHz9UtgLCVe1
         9eFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753775614; x=1754380414;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xsVo12V6n1cHZPjfQGvjTgS28eByrDkHggKW6JJVbsg=;
        b=J3n1v2q2APGObG2ihI6lPpJE9dtbMeiDQFcMz87ZAt5rvfGZ8z25obYSUYIFPmsXnp
         O2bxSrHUnQ9lfwhnEa7NWKW99ZAp2D/1V9C3h+77lMpFuCvUXa6m/Tb62tAc3fpVzk3R
         +4iayeGxrwm5YVf/h26WTNnjwr8qlr8Zofj1hZUxQDx/zZku2Kh8EKOejb8T0SiEjzQl
         BVvM24dFU2IKvIiONQVWNtDKW6jdJJME0q90Vch2kT17cayXUek40lDn6OVl6T8sEEA1
         88uj2LfvAybr2tmL2y4rQtTAHCgyNDqSGo1PDCSmp5W3CeIQeBioD6F5kHWZHrnEE2j6
         F0Gg==
X-Forwarded-Encrypted: i=1; AJvYcCVQkDwUfV1m0KAr4FZUdLkRgZjPYFMv6IDzJIgDgw9ar6yQBZnYU+SYtm1fZRadZIBSEkFbhGY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPXLOLsJ/NNuNVSUsUr+eXTagBi2SXx+AwydmmNCC5EnrrJ+CF
	TRoZvCLyqOjfCmyr8MXLJ1g2ZVC8Jhd6sE+Q3huOIUxd9PPQJwmmOe7x
X-Gm-Gg: ASbGncuVnCIsDN6AsKn9mSdRr18aJfGCsIpDK4mCY5IbI0AcQKcOJF4vbQeDqH7qgOX
	67L4MV8wnWxmNo4n5JrbcsEzKARVjKPynLXR+G6Rs4vfdOzP4QXDAN6ZYFJhT24SlgLAvkGOiX3
	G+EZIjnpB53nLHidRbGsGipbly9s+IWWeREucWL9okBcs6HX5/0c5JJiiK5CiSXt9HWAfppwuEi
	gkClaE3mXBWfnyBbBXYAY5Puvu9Q5p2a74PLONmZdyi6NKFLYSjfywVhNaP7tla2BZMuhK3S1UF
	I3VlWRRZXi4aWxhyhBMCBggGpn51dCdWY0qRRaQLScCBj6AAL/mf/w5Py4zUhOmjfIopOBDnPGb
	7h/es0Bw6KCLRlIdRM49ryw==
X-Google-Smtp-Source: AGHT+IGAnknk8rhP20f+2sNuwxA4iW0E1pa7hcWsSRXI9dwJsSvI+o2WMSlmcCRhgf1zJ9FE5orwQQ==
X-Received: by 2002:a05:6402:2789:b0:615:4655:c74c with SMTP id 4fb4d7f45d1cf-6154655ca5emr5234235a12.31.1753775614152;
        Tue, 29 Jul 2025 00:53:34 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61556326ee7sm1444188a12.55.2025.07.29.00.53.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jul 2025 00:53:33 -0700 (PDT)
Date: Tue, 29 Jul 2025 07:53:33 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>,
	David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v2 9/9] mm: rename vm_ops->find_special_page() to
 vm_ops->find_normal_page()
Message-ID: <20250729075333.47jnxp7fly5wfx6n@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-10-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717115212.1825089-10-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, Jul 17, 2025 at 01:52:12PM +0200, David Hildenbrand wrote:
>... and hide it behind a kconfig option. There is really no need for
>any !xen code to perform this check.
>
>The naming is a bit off: we want to find the "normal" page when a PTE
>was marked "special". So it's really not "finding a special" page.
>
>Improve the documentation, and add a comment in the code where XEN ends
>up performing the pte_mkspecial() through a hypercall. More details can
>be found in commit 923b2919e2c3 ("xen/gntdev: mark userspace PTEs as
>special on x86 PV guests").
>
>Cc: David Vrabel <david.vrabel@citrix.com>
>Reviewed-by: Oscar Salvador <osalvador@suse.de>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me
