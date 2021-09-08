Received: from ozlabs.org (bilbo.ozlabs.org [203.11.71.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAAC72
	for <nvdimm@lists.linux.dev>; Wed,  8 Sep 2021 05:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1631077342;
	bh=ZJ9IP11air76uLBrwqyv2OTaxFR4vOy54e7VeF1rCiY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=kfRr8vD7icgv2v2+w+tm32x3Xp2Wv5FN+A97nD6c6ajDrWjI/o9aWMh/y/nOFXvfz
	 iStJLCnFV17XC/S+Zf2Oc5ZaSWjmhl/4vFiH+cIfpcM0jfO6m1fzSuNDPQx1AAgJzY
	 KmAxrvbFle7hk9YmegqOxBdDRlVG7oStfL0ZeZZX7rzsf6yygfD7NGt88+TWWWpWlo
	 to8enLEPEVrd7p3CCm/CpnbyiD6j0zkhjFE/qjOa3dd951E47YAzHBtYUWcsyzjAub
	 o6GJSK9HrYxwuA+6ljAT+gipxBABDElZSMRMLOE4Kh9jMKJfmePTecBL7eXNIxpp5C
	 0Biju6gd9VBYg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4H493y1Zp3z9sf8;
	Wed,  8 Sep 2021 15:02:21 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com,
 vaibhav@linux.ibm.com, dan.j.williams@intel.com
Subject: Re: [RFC PATCH v2] powerpc/papr_scm: Move duplicate definitions to
 common header files
In-Reply-To: <163092037510.812.12838160593592476913.stgit@82313cf9f602>
References: <163092037510.812.12838160593592476913.stgit@82313cf9f602>
Date: Wed, 08 Sep 2021 15:02:18 +1000
Message-ID: <87sfyfmzhh.fsf@mpe.ellerman.id.au>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Shivaprasad G Bhat <sbhat@linux.ibm.com> writes:
> papr_scm and ndtest share common PDSM payload structs like
> nd_papr_pdsm_health. Presently these structs are duplicated across papr_pdsm.h
> and ndtest.h header files. Since 'ndtest' is essentially arch independent and can
> run on platforms other than PPC64, a way needs to be deviced to avoid redundancy
> and duplication of PDSM structs in future.
>
> So the patch proposes moving the PDSM header from arch/powerpc/include/uapi/ to
> the generic include/uapi/linux directory. Also, there are some #defines common
> between papr_scm and ndtest which are not exported to the user space. So, move
> them to a header file which can be shared across ndtest and papr_scm via newly
> introduced include/linux/papr_scm.h.
>
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> Suggested-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
> ---
> Changelog:
>
> Since v1:
> Link: https://patchwork.kernel.org/project/linux-nvdimm/patch/162505488483.72147.12741153746322191381.stgit@56e104a48989/
> * Removed dependency on this patch for the other patches
>
>  MAINTAINERS                               |    2 
>  arch/powerpc/include/uapi/asm/papr_pdsm.h |  165 -----------------------------
>  arch/powerpc/platforms/pseries/papr_scm.c |   43 --------
>  include/linux/papr_scm.h                  |   48 ++++++++
>  include/uapi/linux/papr_pdsm.h            |  165 +++++++++++++++++++++++++++++

This doesn't make sense to me.

Anything with papr (or PAPR) in the name is fundamentally powerpc
specific, it doesn't belong in a generic header, or in a generic
location.

What's the actual problem you're trying to solve?

If it's just including papr_scm bits into ndtest.c then that should be
as simple as:

#ifdef __powerpc__
#include <asm/papr_scm.h>
#endif

Shouldn't it?

cheers
