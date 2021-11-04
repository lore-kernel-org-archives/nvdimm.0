Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F8B2C96
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 16:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rs5XFE2p3p3CMKTDl6TOuIxFYCbdl7avFTlYX31+tUc=; b=iRIygY7BD5DScAJoQTqjyvK7QG
	+tLqNCE/gjyDz1wqK4+SnUYXRTw8XEhgHirqlTXplM0Hb8wLAYsULS7xWUbFgEl4KnTd432rrF2vb
	Vtrl1ugChnuuQeD2kXe/YjoVxEzxrAoPSvZowXBCyti6X1U7D0pwVn+w+J4sA/86CZuLDVE+/Avqq
	9h6GKkdJOoDv3OK8s4wrN72+gytYad/p8MSDrXre2Tx0K242cAQFbf8PRmKSUbMiA9FO4iPZNiJQG
	fcCy2AENe/ZqFhp7If7l2MFpIYMKZk+krmdIKwLnXvHnUXOgD9chjcPkvnalXR2tl1D3BkXb6EiEb
	DAxwDzdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mifDs-009MJg-0A; Thu, 04 Nov 2021 16:04:16 +0000
Date: Thu, 4 Nov 2021 09:04:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>
Subject: Re: qemu-emulated nfit devices disappeared
Message-ID: <YYQEfxpVlxWjXgAU@infradead.org>
References: <YYOLRW7yx9IFn9mG@infradead.org>
 <CAPcyv4hU+dFYc3fXnGhBPAsid03yFYZSym_sTBjHeUUrt6s5gQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hU+dFYc3fXnGhBPAsid03yFYZSym_sTBjHeUUrt6s5gQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 04, 2021 at 09:00:01AM -0700, Dan Williams wrote:
> > Any idea what might be missing in the attached config?  This seems to
> > be independent of the tested kernel version (5.14, 5.15, master).
> 
> Can you share your qemu command line

qemu-system-x86_64 -enable-kvm \
	-machine pc,nvdimm=on \
	-m 4096,slots=8,maxmem=32G \
	-smp 4 \
	-kernel arch/x86/boot/bzImage \
	-append "root=/dev/vda1 console=ttyS0,115200n8" \
	-nographic \
	-drive if=virtio,file=/home/hch/images/jessie.img,cache=none \
	-object	memory-backend-file,id=mem0,mem-path=/home/hch/images/test.img,share=yes,prealloc=no,align=128M,size=10G \
	-device nvdimm,id=nvdimm0,memdev=mem0,slot=0,label-size=2M \
	-object memory-backend-file,id=mem1,mem-path=/home/hch/images/scratch.img,share=yes,prealloc=no,align=128M,size=10G \
	-device nvdimm,id=nvdimm1,memdev=mem1,slot=1,label-size=2M \


> and the output of:
> 
> ndctl list -vvv


[
  {
    "provider":"ACPI.NFIT",
    "dev":"ndbus0",
    "dimms":[
      {
        "dev":"nmem1",
        "id":"8680-57341200",
        "handle":2,
        "phys_id":0
      },
      {
        "dev":"nmem0",
        "id":"8680-56341200",
        "handle":1,
        "phys_id":0
      }
    ],
    "regions":[
      {
        "dev":"region1",
        "size":10603200512,
        "available_size":10603200512,
        "max_available_extent":10603200512,
        "type":"pmem",
        "iset_id":52512795602891997,
        "mappings":[
          {
            "dimm":"nmem1",
            "offset":0,
            "length":10603200512,
            "position":0
          }
        ],
        "persistence_domain":"unknown",
        "namespaces":[
          {
            "dev":"namespace1.0",
            "mode":"raw",
            "size":0,
            "uuid":"00000000-0000-0000-0000-000000000000",
            "sector_size":512,
            "state":"disabled"
          }
        ]
      },
      {
        "dev":"region0",
        "size":10603200512,
        "available_size":10603200512,
        "max_available_extent":10603200512,
        "type":"pmem",
        "iset_id":52512752653219036,
        "mappings":[
          {
            "dimm":"nmem0",
            "offset":0,
            "length":10603200512,
            "position":0
          }
        ],
        "persistence_domain":"unknown",
        "namespaces":[
          {
            "dev":"namespace0.0",
            "mode":"raw",
            "size":0,
            "uuid":"00000000-0000-0000-0000-000000000000",
            "sector_size":512,
            "state":"disabled"
          }
        ]
      }
    ]
  }
]
