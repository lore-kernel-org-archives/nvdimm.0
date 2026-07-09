Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484F63BB12B;
	Thu,  9 Jul 2026 23:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783641455; cv=none; b=AL7ANBPjN3J/L3sdUTTqlGgh+w9YwgYtzfhGjGypFb1Ah9hiaJm08sSPbnyin1VZYDpiXHr8sepHIZBVYfDCRGm/5XOF7uL8lHGKvN/1KKnWRtUvY7dcY365GJhIsdlR/dl51/Bd5Dp47Bp4Q5/t2dteFPsuaLwN0JQKO9d8ED0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783641455; c=relaxed/simple;
	bh=ijeMi1ynINCbfpsysZOXJoU1MZ/yQ6o1QBJh/Ou0gAQ=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=sNhPR/87LSf050OAfQ53FuqQRj7IV/6wsOjLbWlyaot6XMUDNFfAWJw3Y8cC2SKuTozo3XCsPGNB72S4kdL+MFMwkuJtL6/s7EfxdAK3GZhuzXC/zpGRwJqUbC/GbNEsQm+rB76CPBglAMqD6+pCpfytxlcPbk4VOZzT31bYXTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGvMFIuG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGvMFIuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418A01F00A3D;
	Thu,  9 Jul 2026 23:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783641454;
	bh=NL6KkE+XGM13rjECEPlDsP8sDmlO2+4iY80eSoJW34k=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=VGvMFIuGD04PIRzU/JMeGvWpJXoTWA+IBrWJ4DETddqsvMfFiGavTTa9l63r0ClWv
	 X2UUQqNqpZqczRFyLqhZ+Zy8m15reHdQPTxmbUIl38NqaY/9+pMPbWiYC4uxdsvauQ
	 wiyhThJeiv2vh4H7xyufBRg8Jf3VvutnySvhp/UkfByFzJVEb/o6mL59688vpOGA8E
	 /KtI4FyfFU6/yE1N8/6ajHygAZKQzXhv4MUIjJQ7ZlAJqRmRYhZpdgugODmzwu+OMS
	 LmeVZGAdUBW7l7GzygghdDpLsz0oELPEdGv7JVw3JmP3iGheo/4T7jidFlKAypbciy
	 7bI+bsP27Yw9A==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5ED64F40068;
	Thu,  9 Jul 2026 19:57:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 09 Jul 2026 19:57:32 -0400
X-ME-Sender: <xms:bDVQalWT3kkP1O_nPlEUgaGq8m8QWlO5PPNjznrDe7d1CpTWIfMANg>
    <xme:bDVQalv5hmJ1CwhK2dgiJKfqcKH5_0MDF8nquspQ3CIiab0qCEzQOUNU3wTkB6jqA
    qux6Ekbzjl6ev_KByOlE4DpQciHdJVr0JS7N5fHu8-OEkyJk7RLkY4>
X-ME-Received: <xmr:bDVQavNLOvwweJeepDKvjUahneSQU-R9SYF3Ap5jl8v4MTmiRC2Md5MF496hZvJ_k9lFsj2yuAX9-jTBk3671HtMbzuA8Bg0NRc>
X-ME-Proxy-Cause: dmFkZTFRjNBlnTz3PRsAmwjqRoF0mrjGm979SwqAKHEfthIBDq5uh/i9WRUkVW7VZSf//w
    YDoaw7hRG798DaAYdC6UbfhFGRdHF+jU+/jGu6HBle2Ytf+9RWyMwBDwRmckEaZLf/nUyQ
    SKi5sJRgbDjlp94ASRYw/4muCvkc2xHnl/vxqUx1y1DhspUjPMoJnbB/bl00rpb5PWiQyg
    GTtZWI4G6plLyhOdjNWH8CBGphBXLtH3D2Pvho0pAK+KnWiAORXsSOpMdV4xD7ID8QXYje
    a9mh9aiUSp78AdFrJ9O2B3vkzu06KG1gqyHdViPBwiRVrcIhbVPJi05ziCPPBR/N6vYfer
    6lrpXziKcnjva9wT7p5QUwgxDdC5jjdwT7fXiZidMKAEs3vLpiGVt16GoilNTbBE1Swe66
    lq1nYogPtBgSjvZCHT/YZLpCIqUO4TamHC1Gj5FtyOihURCc/3jiGGJS5HrnflvJVUhjxl
    uPu1tEET6rrY+yW5GgTNYjuDoKs+MzBD57qey3Z58xdp6wOjNRKNBRIG8N4BLdwR9dsmCv
    A4RIo/MDKkVvsbyt2hA+z7nruReU0o4mcD3lQXH5OqBkbo9AE/nGnLS1/bS/nnG97VTtRr
    clacuChAjPCOEchopHVZNuyYh3E0NUuVP+WPVNPQEQOSK3N74GMuftNUjPxA
X-ME-Proxy: <xmx:bDVQasnnBxeuM7jroXxksAQB9zn6duvpKmyvN9LZYwI-PdaHUkJUKA>
    <xmx:bDVQatz0AT56AL-iX_O4imnfAPCevJDLonBYOOcGBR4lexJTusoU-A>
    <xmx:bDVQalDdKFvxjIjyCfZD792xaNLb2nqmtQGGLIeFu5A_OdS7ISVbsQ>
    <xmx:bDVQal5BbtDERhJ51QOg_cveb9aqQk1z5niWGshAPguYIvTxzRtlwA>
    <xmx:bDVQap1K540U56JdRBFV8JSNUnGOGG8a2VUV2cYjZ6gcar-XwgSzqP4U>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Jul 2026 19:57:31 -0400 (EDT)
Date: Thu, 09 Jul 2026 16:57:30 -0700
From: "Dan Williams (nvidia)" <djbw@kernel.org>
To: Gregory Price <gourry@gourry.net>, 
 "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, 
 nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, 
 linux-cxl@vger.kernel.org, 
 driver-core@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, 
 kernel-team@meta.com, 
 david@kernel.org, 
 osalvador@suse.de, 
 gregkh@linuxfoundation.org, 
 rafael@kernel.org, 
 dakr@kernel.org, 
 vishal.l.verma@intel.com, 
 dave.jiang@intel.com, 
 alison.schofield@intel.com, 
 akpm@linux-foundation.org, 
 ljs@kernel.org, 
 liam@infradead.org, 
 vbabka@kernel.org, 
 rppt@kernel.org, 
 surenb@google.com, 
 mhocko@suse.com, 
 shuah@kernel.org, 
 iweiny@kernel.org, 
 Smita.KoralahalliChannabasappa@amd.com, 
 apopple@nvidia.com, 
 Hannes Reinecke <hare@suse.de>
Message-ID: <6a50356aa7a4a_3cabcb1008a@djbw-dev.notmuch>
In-Reply-To: <alApfp2z9Thyan16@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
 <6a502267b17cc_3b7ee51008f@djbw-dev.notmuch>
 <alApfp2z9Thyan16@gourry-fedora-PF4VCD3F>
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Gregory Price wrote:
> > So the "unknown" case does not need to be here.
> >
> 
> mhp_online_type_to_str can technically return NULL, seems better to not
> just let a NULL dereference sit latent even if we can visually tell it
> can't happen today?

Oh, makes sense I was thinking "unknown" was only a result of the
drvdata missing case.

> > > +	if (dax_kmem_state_is_online(data->state)) {
> > > +		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
> > 
> > I like that the BUG() is avoided, but I think these should stay
> > dev_err() given the severity.
> > 
> 
> I had to go back to calling remove_memory() by default given different
> feedback, but I think if anything I will just modify the BUG() to a
> WARN() and call it a day.

ack.
