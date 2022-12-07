Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4C5362
	for <nvdimm@lists.linux.dev>; Wed,  7 Dec 2022 10:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670409215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ls/fVzNOQDXdkwGawkCzgkRpahtmHyBL8VCkLV4JQsI=;
	b=H2L7kM5wAVgbHqdpQThXS7p8H6gWh2PWw+Ek94XMwdGoeJ3D7fsV9AyhS29jSQ/E2dtGQW
	0olq1j5Rem2iTLXGlG7p5BXzQam/wHBxafO7R4dBtn31OhhkX5ILevthYFIftV7wrj5IH7
	6nQB8sSNPvsOk0MS35yXzGaqUcGKm14=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-654-h6GkhD_hOgOb81o2ssud0g-1; Wed, 07 Dec 2022 05:33:32 -0500
X-MC-Unique: h6GkhD_hOgOb81o2ssud0g-1
Received: by mail-wm1-f70.google.com with SMTP id m17-20020a05600c3b1100b003cf9cc47da5so9783240wms.9
        for <nvdimm@lists.linux.dev>; Wed, 07 Dec 2022 02:33:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ls/fVzNOQDXdkwGawkCzgkRpahtmHyBL8VCkLV4JQsI=;
        b=UPBlaBTALQpkLGeiYyR6wZlkaq9XqBBW7iqwgVxNK1ZHJa4nq4n5M447LuLebfpgJU
         b/zwPuQVq4ib4Bwds8GN3JFlzpTAkxX+jK8qKF6LRBQ7bX97oeZnAoJhH5FGN1dy4Ta6
         ti7Bs7z1mwA9GH7gAi3RmfQp8Xfipfnc0L4tZvrbud11tlVR0nkkbVZKjcIcPlewAm+q
         haWhtXxncNkOy6whOhoBdRfSIWxOFYDELtaFeNXHie2ChsDWPIOmF4vIlTBWYecspNuU
         wr5axB6tYosp7/JVry1WpMC9O68M04kYHhKsmvxmE7AgxNTADlEiaPZHhn2OSM2S2X1M
         yvKg==
X-Gm-Message-State: ANoB5pkEOakLzRnuzkPnvM1tmnUAnC0vZlAt2Sxq43IOWNrxoyqu85z+
	nQGRc/84V4m/wXnq2B+aqcDZszwC9NRdTsqdQZce5wvTl8061NIicoLb/mdq6xxAUmRGZiPS/GM
	MimkC3ceDCcoGw4/q
X-Received: by 2002:a5d:6dd1:0:b0:236:75a8:58d with SMTP id d17-20020a5d6dd1000000b0023675a8058dmr56602615wrz.295.1670409211073;
        Wed, 07 Dec 2022 02:33:31 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6FBlRBE2GeVd3WJhHDz0cWwP9kKA/AUXb7mzTw2ZMVDwXZf0YLLk4DOpcAQ2mrMfXIGB+xvw==
X-Received: by 2002:a5d:6dd1:0:b0:236:75a8:58d with SMTP id d17-20020a5d6dd1000000b0023675a8058dmr56602601wrz.295.1670409210856;
        Wed, 07 Dec 2022 02:33:30 -0800 (PST)
Received: from redhat.com ([2.52.154.114])
        by smtp.gmail.com with ESMTPSA id b18-20020a05600010d200b002423a5d7cb1sm16105958wrx.113.2022.12.07.02.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 02:33:30 -0800 (PST)
Date: Wed, 7 Dec 2022 05:33:26 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>
Cc: Michael Sammler <sammler@google.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mina Almasry <almasrymina@google.com>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Michael Sammler <mich.sammler@gmail.com>,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2] virtio_pmem: populate numa information
Message-ID: <20221207053242-mutt-send-email-mst@kernel.org>
References: <20221115214036.1571015-1-sammler@google.com>
 <CAFPP518x6cg97tK_Gm-qqj9htoydsBtYm5jbG_KivK5rfLcHtA@mail.gmail.com>
 <3f7821a0-7139-7a97-ab24-dfca02811fc0@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <3f7821a0-7139-7a97-ab24-dfca02811fc0@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 07, 2022 at 05:09:42AM +0100, Gupta, Pankaj wrote:
> +Cc [MST, virtualization-list]
> 
> Hi Dan, MST,
> 
> > This patch is reviewed and tested. Is there anything that needs to be
> > done from my side (e.g. sync with mainline)?
> 
> If there are no further comments, Can we please merge this patch?
> 
> Thank You,
> Pankaj


I'll take a look. Generally if you want my attention you
should CC me on the patch.

Thanks,
MST

> > 
> > (Adding my alternative email address to this thread as I will soon
> > lose access to the address I am sending this email from.)

