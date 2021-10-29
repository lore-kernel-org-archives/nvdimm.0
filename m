Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B23572
	for <nvdimm@lists.linux.dev>; Fri, 29 Oct 2021 15:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=SiX9UHoKQRXFz7uP18kxGHUXOhLYqA4eqNBdQkR4TXE=; b=VdHWj0+nTUKPpKWf81O53GmJ4F
	Y7kKTY7MJ2Zcuu77lNqX67xwl83XeEbX0np9vqqR44i+AQylcpAnM1v4qlYv9h29Kya5GKCN2ybE3
	W+t52oiDWqFAjYFnW+1N7gFe8c18KfnHZFF2Tn1ky0WyEOyvINHO40OgAXuCfudialdyEi5OpoaKo
	B/pw1X7LSoGoe6cqWosHKEVzjEwx5OxDuOlTzkAIRMCNRp0Dqu779rbzrQ1EE/5/d+GI/7ilbja7c
	C4g1+CtTsxilGDlvOj/9Etq7zQgegEtyQsoLdShVbdRgvac18HmoqGjHShEnXTzy9TdCj3Sno6JbZ
	M0Pz7m3Q==;
Received: from [2602:306:c5a2:a380:b27b:25ff:fe2c:51a8]
	by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mgTRS-00D6jk-Vo; Fri, 29 Oct 2021 15:05:15 +0000
Subject: Re: [PATCH 10/13] ps3disk: add error handling support for add_disk()
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
 <20211015235219.2191207-11-mcgrof@kernel.org>
From: Geoff Levand <geoff@infradead.org>
Message-ID: <01e79b30-8ac0-c384-d57d-7c79e7f244c2@infradead.org>
Date: Fri, 29 Oct 2021 08:05:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20211015235219.2191207-11-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Hi Luis,

On 10/15/21 4:52 PM, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

I tested your 20211011-for-axboe-add-disk-error-handling branch
on PS3 and the ps3disk changes seem to be working OK.

Tested-by: Geoff Levand <geoff@infradead.org>
