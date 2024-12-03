Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1853E1F427D
	for <nvdimm@lists.linux.dev>; Tue,  3 Dec 2024 14:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733234882; cv=none; b=MFE6K6ybZnUxElbjqd1M/bjs3T4PkB8WX0STDpH0qB8r5KZw9cU84AIsD8y6A5jgCkgtsQLmi2TO0icAEpPScT9h7N+lrq4qrsXv4rkciwDnA6y+74pADt04dFKW9KfMcVGdLP7ojH6RL3gb+yB8xdAXiso2WMAWzKigZ4MSJR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733234882; c=relaxed/simple;
	bh=fHTskvsLjld8Oq3wof1WoW/ro1iLNuhMDVshgcSrpsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+57t4x1+Yz9XBs5niD3Ds93dBzT0CAhg+qQsglIz0ZLRGwfTLZuCz7uHr1G2oR9M52uc1kVsGsJtD/wB0ptafff0dUxhey59RRh7i5ur7j/YWcUbIdurgkIC/35aozTTc4n0CvqNFuyMT2MYwpbD2xABdukxieKqSLQzGRgkBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de; spf=pass smtp.mailfrom=t-8ch.de; dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b=L1SEFC6C; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=t-8ch.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b="L1SEFC6C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
	t=1733234875; bh=fHTskvsLjld8Oq3wof1WoW/ro1iLNuhMDVshgcSrpsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L1SEFC6CwLYUTcqqqze527r7IWIE4XsyoMQ1CGzSu2Lo7wpen1OO065Nb6zA+snIr
	 s3/fB4myqry70R09PnBsloM8UYaMMYtq2RVACVaLKZRaHFcnQ6Cg6M23NYb/aG/4oS
	 rGquyCmF69KPSlVFe8JS1cvEe5EsWFKP+TSwl24Y=
Date: Tue, 3 Dec 2024 15:07:55 +0100
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Zijun Hu <zijun_hu@icloud.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Chun-Kuang Hu <chunkuang.hu@kernel.org>, 
	Philipp Zabel <p.zabel@pengutronix.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Jean Delvare <jdelvare@suse.com>, 
	Guenter Roeck <linux@roeck-us.net>, Martin Tuma <martin.tuma@digiteqautomotive.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Andreas Noever <andreas.noever@gmail.com>, 
	Michael Jamet <michael.jamet@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, 
	Yehezkel Bernat <YehezkelShB@gmail.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Bartosz Golaszewski <brgl@bgdev.pl>, Andrew Lunn <andrew@lunn.ch>, 
	Vladimir Oltean <olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Takashi Sakamoto <o-takashi@sakamocchi.jp>, Jiri Slaby <jirislaby@kernel.org>, 
	Heikki Krogerus <heikki.krogerus@linux.intel.com>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, 
	Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, 
	Mike Christie <michael.christie@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Nilesh Javali <njavali@marvell.com>, Manish Rangankar <mrangankar@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Davidlohr Bueso <dave@stgolabs.net>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Alison Schofield <alison.schofield@intel.com>, 
	Andreas Larsson <andreas@gaisler.com>, Stuart Yoder <stuyoder@gmail.com>, 
	Laurentiu Tudor <laurentiu.tudor@nxp.com>, Jens Axboe <axboe@kernel.dk>, 
	Sudeep Holla <sudeep.holla@arm.com>, Cristian Marussi <cristian.marussi@arm.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-hwmon@vger.kernel.org, linux-media@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-gpio@vger.kernel.org, netdev@vger.kernel.org, linux-pwm@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux1394-devel@lists.sourceforge.net, 
	linux-serial@vger.kernel.org, linux-sound@vger.kernel.org, open-iscsi@googlegroups.com, 
	linux-scsi@vger.kernel.org, linux-cxl@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-block@vger.kernel.org, arm-scmi@vger.kernel.org, linux-efi@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, Zijun Hu <quic_zijuhu@quicinc.com>
Subject: Re: [PATCH v2 00/32] driver core: Constify API device_find_child()
 and adapt for various existing usages
Message-ID: <8fb887a0-3634-4e07-9f0d-d8d7c72ca802@t-8ch.de>
References: <20241203-const_dfc_done-v2-0-7436a98c497f@quicinc.com>
 <g32cigmktmj4egkq2tof27el2yss4liccfxgebkgqvkil32mlb@e3ta4ezv7y4m>
 <9d34bd6f-b120-428a-837b-5a5813e14618@icloud.com>
 <2024120320-manual-jockey-dfd1@gregkh>
 <b9885785-d4d4-4c72-b425-3dc552651d7e@icloud.com>
 <8eb7c0c54b280b8eb72f82032ede802c001ab087.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8eb7c0c54b280b8eb72f82032ede802c001ab087.camel@HansenPartnership.com>

On 2024-12-03 08:58:26-0500, James Bottomley wrote:
> On Tue, 2024-12-03 at 21:02 +0800, Zijun Hu wrote:
> > On 2024/12/3 20:41, Greg Kroah-Hartman wrote:
> > > On Tue, Dec 03, 2024 at 08:23:45PM +0800, Zijun Hu wrote:
> [...]
> > > > or squash such patch series into a single patch ?
> > > > 
> > > > various subsystem maintainers may not like squashing way.
> > > 
> > > Agreed, so look into either doing it in a bisectable way if at all
> > > possible.  As I don't see a full series here, I can't suggest how
> > > it needs to happen :(
> > > 
> > 
> > let me send you a full series later and discuss how to solve this
> > issue.
> 
> It's only slightly more complex than what we normally do: modify all
> instances and then change the API.  In this case you have an additional
> problem because the prototype "const void *" will cause a mismatch if a
> function has "void *".  The easiest way to solve this is probably to
> make device_find_child a macro that coerces its function argument to
> having a non const "void *" and then passes off to the real function. 
> If you do that in the first patch, then you can constify all the
> consumers and finally remove the macro coercion in the last patch.

Casting function pointers like that should be detected and trapped by
control flow integrity checking (KCFI).

Another possibility would be to use a macro and _Generic to dispatch to
two different backing functions. See __BIN_ATTR() in
include/linux/sysfs.h for an inspiration.
This also enables an incremental migration.


Thomas
