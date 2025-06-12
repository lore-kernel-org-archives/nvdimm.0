Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3094E2C3770
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 18:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749751373; cv=none; b=tP27dCzZ055WsjIqsl7SQN2SDlsHWiDnF2nHAWweYg4ShT0NGH/y9+nSIkxKiQfFS3BbEyFuhbcRdInb+7yA+MvYhgvpqlu0OH2UN1YFQNEeNUMI38vef6G+X5mnCXLc6Bhh/GV3mKd6cMzavffwESgaO9pjl4cWo41Jppr+lZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749751373; c=relaxed/simple;
	bh=7xWw5aJLm8rN49o70JV7Et+XL03bPweLX55FIjhoBWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KGy9sb56PhR95d2aXuykqYfKlKJvtvxTeJc/kWK8EiD0Xx+rNdZXuF1/zxKk4Lmw9qKp1Z8A0YdoNWsm3s4EujVHEoyD0rAEfiuHWZ9kxLBLVgCYKZ2uglvYsuWW6rVqMk786kU6jz1yRpGHycvgSv/KUPajmNQfKhHZ97BVfNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ntJ0vX4h; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ntJ0vX4h"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6facba680a1so15235096d6.3
        for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 11:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1749751371; x=1750356171; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GDDRWPX1lH08t+vNjXng50l3/jIs9pZf702xFyzNrfY=;
        b=ntJ0vX4hrgmAySX6abG31aXcQdZimA0apKSrzCqQd7ekfQSoic9nk4qm8x+ITokIgr
         X50T1ItU3+vaFvZi8Q8RUK1jMM6QQ9biVT1JtV6Oylw12lma0FRY75a93kh1UI4yYfSk
         +2ckXpxO08kP8mEFOv3Kt5Ycz35ZD6Kp4bLkSZuEwMOk6hNiArMAqX0A0DgB/QV8+LuH
         LLpWElNzV0RIgsnSYIVh7gERdaDwEKpks0oWA0hU1kFzlIcrd/prBEbBE8/8sr2yj785
         BwbLZnEAb8EfEto+pq7OHJfkTk2RD5IogItcpGPsBrN+kNf0ZW0Ure4jmL7Z8dYvwLRO
         pkrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749751371; x=1750356171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GDDRWPX1lH08t+vNjXng50l3/jIs9pZf702xFyzNrfY=;
        b=I4gb3BS3GcxMoOct61HNQhrKHEwW5BHLsti2qC1xk6pcmFQDhSK+B+QY6NozNx0Xla
         SThN5IV/hYxEMIWiUgN+spQMOJk9sqtppFVR4sZuUCYQJTduy44std8YKcrIwewGA7J7
         MlnsywqvfzCM5YOgXIKIPHJNbn7pj6rl8TQheKmpgnXUnHR/hmMSJKssLQ1DC1BZlXN6
         G7zIk7TfqE4+fQS867ZfxC4xOQk9loS94fTpSik+IUPMM7CQX2ItS9MuQm27BNKwMhiO
         HVIKPu4cl3uwRkLz+TjBQI8aR1qq84HzrMjuq7BMqbEhtO+mkaDuqEEsfLxbtU55b+Cd
         8TRg==
X-Forwarded-Encrypted: i=1; AJvYcCVVz09BXVkii4D66wXr6BbLVfzrKiRRXE0WbxIWiKdd1GJlA45/ksWeFut7r2fFYJH7kBxd8XU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/RdLWXJ+ENnycLN1vCc7KWk81XshJPSe6gJYkoUdUu1tRKyCj
	DvVF/b4aLmtA6G8+Uw4XgWlEMnGkZGUtmHWbR0e3dciic8UaYiNnOqULUfpzGQ6dttM=
X-Gm-Gg: ASbGncs9eSRfsNJbowz8Bx07pusgNFH5zj1KF9RHzEKod3A1KSjEGlEL4HA65AUlvCh
	fJfkdxcR5Kx3QoQTURxEj6nh1ifc+uzYjdXp2wDw31XIF4S5R4qMANsHY3to/sgN2DZs4m7c05A
	we/n7xj3a7c2lxhm8FffV9N4j2tXZNFO3Ttu0h92ZVM0iBhsIZPMir9cgEQJuoXezlJNNT5PqTq
	p90rAys3bt7nxG7R7uhspPyVEBJqMkO+yEvxNSeH/Ygm1ahGvrJ1IdTNegGkqf0+/3XuL0OV4uS
	AnFHsvWVJvqS0uLcHXTYmFZ/BfXXzYW+UIjOX6q6Wd3T8hdUgbugHHUMUDR0izz5Da32hqmeGyV
	n4QnMaM93SvU61uTa0lmQ6JGDERMvFb86M8VZXw==
X-Google-Smtp-Source: AGHT+IErLirqZ/IjWI/XgEsozLii1/UP6Pds6ZK0pCCFWbV1P+4pjEqskuPc1d9m/qNp3cmq3DvELw==
X-Received: by 2002:a05:6214:e86:b0:6fa:d95d:d0b1 with SMTP id 6a1803df08f44-6fb3d2b2155mr7744516d6.24.1749751371067;
        Thu, 12 Jun 2025 11:02:51 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb35c8ee5fsm12595756d6.122.2025.06.12.11.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 11:02:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uPmGI-00000004kgd-0Li5;
	Thu, 12 Jun 2025 15:02:50 -0300
Date: Thu, 12 Jun 2025 15:02:50 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v2 3/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pud()
Message-ID: <20250612180250.GC1130869@ziepe.ca>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-4-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611120654.545963-4-david@redhat.com>

On Wed, Jun 11, 2025 at 02:06:54PM +0200, David Hildenbrand wrote:
> Marking PUDs that map a "normal" refcounted folios as special is
> against our rules documented for vm_normal_page().
> 
> Fortunately, there are not that many pud_special() check that can be
> mislead and are right now rather harmless: e.g., none so far
> bases decisions whether to grab a folio reference on that decision.
> 
> Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
> implications as it seems.
> 
> Getting this right will get more important as we introduce
> folio_normal_page_pud() and start using it in more place where we
> currently special-case based on other VMA flags.
> 
> Fix it just like we fixed vmf_insert_folio_pmd().
> 
> Add folio_mk_pud() to mimic what we do with folio_mk_pmd().
> 
> Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/mm.h | 19 ++++++++++++++++-
>  mm/huge_memory.c   | 51 +++++++++++++++++++++++++---------------------
>  2 files changed, 46 insertions(+), 24 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
