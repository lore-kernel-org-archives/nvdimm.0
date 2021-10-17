Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7D42C81
	for <nvdimm@lists.linux.dev>; Sun, 17 Oct 2021 15:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=70ZKfllBjZHQa1J4GUObwLCze3CU8wCeQiJAaBSPZwY=; b=C4UNljiRQnxqpGr/gZae9CnIWT
	j7Uyl2yYks8L0q03i4Yj6wzbXHZfLRSnndsp7bwE+G+8kSeY6JWp3qOqYzPXZm7xgouB3Y3hUQhtB
	Pk4Hz6DQ4fJj9JpSQmWL3lPFrfCQD6hkq6x6Rwnt4SbkGg8suXrp9MdS/9GwqmQ6jlHlFEgk2ZXtF
	TIxTzVAunQ+vPdosDdlLDCl2JNMPGbY3ukZHFD5HB/10NLbW6nDO6fT48v5VJRLhpzgc3wB6XGEom
	dyYnzfPdzBD/IPULfN37GdDBH1ku04zKJuWqNo9uyCNES4imNkH0NlqGgJMRJ5knyNRf5ELnaJOvh
	Cfc6kr6w==;
Received: from [2602:306:c5a2:a380:b27b:25ff:fe2c:51a8]
	by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mc83d-00ANfc-5J; Sun, 17 Oct 2021 15:26:41 +0000
Subject: Re: [PATCH 00/13] block: add_disk() error handling stragglers
To: Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk,
 mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
 jim@jtan.com, minchan@kernel.org, ngupta@vflare.org,
 senozhatsky@chromium.org, richard@nod.at, miquel.raynal@bootlin.com,
 vigneshr@ti.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, ira.weiny@intel.com, kbusch@kernel.org, hch@lst.de,
 sagi@grimberg.me
Cc: linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20211015235219.2191207-1-mcgrof@kernel.org>
From: Geoff Levand <geoff@infradead.org>
Message-ID: <a31970d6-8631-9d9d-a36f-8f4fcebfb1e6@infradead.org>
Date: Sun, 17 Oct 2021 08:26:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20211015235219.2191207-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Hi Luis,

On 10/15/21 4:52 PM, Luis Chamberlain wrote:
> This patch set consists of al the straggler drivers for which we have
> have no patch reviews done for yet. I'd like to ask for folks to please
> consider chiming in, specially if you're the maintainer for the driver.
> Additionally if you can specify if you'll take the patch in yourself or
> if you want Jens to take it, that'd be great too.

Do you have a git repo with the patch set applied that I can use to test with?

Thanks.

-Geoff
