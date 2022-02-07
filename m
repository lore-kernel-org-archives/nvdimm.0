Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4544D2F28
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 18:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
	Message-ID:From:References:Cc:To:content-disposition;
	bh=fEpCgCTX3h2p5UN6S8G2mb2i3aC8G4ppdXgJ4LAUOGU=; b=XtZxNl7rveoZfo3hm92UT9KtIn
	TtfEzS/obXfk3nfrPZQaNcvNJUwwbQ6FzvaeEldi8mcXvPcHXrxfFOT99cxGORMyDdpOVPqYgWzhi
	NJnUpgdumuFyV2Tyl4IQts6oBLVaEJ6HMSLjCaSC8BxCiLvC8sRYx1T5KoSKEkaCFuFOKFauwDLJT
	qDYAHUO9NbVOKwEI0y/pDnprLXyf0uJTBMutoNPy5QjfIiwWCMAn64wh72jOJz0AvGzbx5ngPzJla
	9IgNxQUju0gJaTa8Q0ExQHFh65YjcZN7/8ClykiaX2fTLk5f5rYdLc6sSPtEu6A4YR4u/mO5qpQUx
	bob8LGjg==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.94.2)
	(envelope-from <logang@deltatee.com>)
	id 1nH7xp-00EVc6-C4; Mon, 07 Feb 2022 10:38:09 -0700
To: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
 "Pan, Xinhui" <Xinhui.Pan@amd.com>, Ben Skeggs <bskeggs@redhat.com>,
 Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Alistair Popple <apopple@nvidia.com>,
 Ralph Campbell <rcampbell@nvidia.com>, linux-kernel@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, nvdimm@lists.linux.dev, linux-mm@kvack.org
References: <20220207063249.1833066-1-hch@lst.de>
 <20220207063249.1833066-7-hch@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <a8c54032-3347-c999-d644-02e6e7d2bfa4@deltatee.com>
Date: Mon, 7 Feb 2022 10:38:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20220207063249.1833066-7-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: linux-mm@kvack.org, nvdimm@lists.linux.dev, nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com, jgg@ziepe.ca, lyude@redhat.com, kherbst@redhat.com, bskeggs@redhat.com, Xinhui.Pan@amd.com, christian.koenig@amd.com, alexander.deucher@amd.com, Felix.Kuehling@amd.com, dan.j.williams@intel.com, akpm@linux-foundation.org, hch@lst.de
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=5.0 tests=ALL_TRUSTED,BAYES_00,
	MYRULES_FREE,NICE_REPLY_A,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
Subject: Re: [PATCH 6/8] mm: don't include <linux/memremap.h> in <linux/mm.h>
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2022-02-06 11:32 p.m., Christoph Hellwig wrote:
> Move the check for the actual pgmap types that need the free at refcount
> one behavior into the out of line helper, and thus avoid the need to
> pull memremap.h into mm.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I've noticed mm/memcontrol.c uses is_device_private_page() and also
needs a memremap.h include added to compile with my configuration.

Logan
