Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21A5808
	for <nvdimm@lists.linux.dev>; Tue, 31 Jan 2023 09:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF2BC433D2;
	Tue, 31 Jan 2023 09:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675156248;
	bh=iQ1Xydi1GvEvZNrYB1OdH3nAEKk7nKI4XluwpZQns+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sid16eamf7gs4IwwoHZC7q2+vEJtUJh1LYFWlfoRq+9pXJ0J21KIw4rFun+zC/bkb
	 y8QhZv3QWQVeyCsld2iGKhMu+lMtE2tl19JvM817z83O/D4q4TjjKizvIzWu5aVa01
	 LCSyV+jltrS5r9p1Tp6h4MpR4zKfldylfZZGNDkQ=
Date: Tue, 31 Jan 2023 10:10:40 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
	Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
	linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/9] Documentation: driver-api: correct spelling
Message-ID: <Y9jbEDPHbBb1hbsZ@kroah.com>
References: <20230129231053.20863-1-rdunlap@infradead.org>
 <20230129231053.20863-3-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230129231053.20863-3-rdunlap@infradead.org>

On Sun, Jan 29, 2023 at 03:10:46PM -0800, Randy Dunlap wrote:
> Correct spelling problems for Documentation/driver-api/ as reported
> by codespell.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: linux-media@vger.kernel.org
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: nvdimm@lists.linux.dev
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: dmaengine@vger.kernel.org
> Cc: Song Liu <song@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> ---

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
