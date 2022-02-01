Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D32E2F26
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 23:59:22 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id k17so16824973plk.0
        for <nvdimm@lists.linux.dev>; Tue, 01 Feb 2022 15:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B+R2Zx0ML/EKvqqWNoD035jGto0p6Ur7g9Wctqz24S0=;
        b=UCunpy71JKDOit4ttSfjBKYqp5/RyIRc0W3fWcBS7EnSLrZb2hbPekd6WiumFNGxbh
         uPGdk1b0Ok+v1S4OwzGXWz2MlKPqTbvncVnPPAFf95ueNPFdrdjdIukRCnpDAd8pg6v9
         qDJ0BmaojFwpmc9JGdWv3Ev/NGxacfMe2u7ImmdJN9BZt1Sy1UpcbKhOQyIuOOsakmuZ
         aYq7fXuAoIGsP5owoVlJe+NAKN+zVi7LWwjWnfa8+I3gKpKZklaijbuKEmaYjtgQqvXC
         cDoPUBgKztx7w6I6NsQKZ7G0DLDdHiUA0qMW9N8shHqHgYvL6wEJyulS2kCwFuusPO7y
         OarQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B+R2Zx0ML/EKvqqWNoD035jGto0p6Ur7g9Wctqz24S0=;
        b=ZQMVZNrBLkjFEtr9vxF2/zCFzx2L9Q341tHc/VRP5gWoJWkniNomEUamAd2Ckc33K9
         Dmx1GCAyZap6v3KZuWFAvvT4j7RUfMQy+yPtBECEWNM5ldfym/iXhmWzqrQ9TlRn8Gq3
         NiGmPlMBvGweDGLju1PtDfhVluogj/CqZF9UvcuwOKZYeLud0ZehCbfM/wL9r58wzaYa
         NgfaRADA3oati8g6/oyveJeCnsbfJuuljvR3eCann3KQ1jGwVNfNApAMzh1O6l6jRggq
         xrjDS9mR+E2Ce/MsLUZnD5VDF8Xiti1o8nAkVi75CFnyZyi76fYSyQe8ZuDmyDc3exZB
         5ewQ==
X-Gm-Message-State: AOAM530bFNayfGCOitd5DNfD+1FiJLnluUYI/Yf7aQWfVSQ9V5zyeBn4
	yzWyN3Du/ijInAAx1wPaEb+FLtAWIH95oI3dczGd2w==
X-Google-Smtp-Source: ABdhPJwnehpby8yp683SdJKAdL2F3StWXxd8JVVi5jbP7vbcqpz39az5sXc/ZEgCSo9OuFwSGV+fpFbdQQe0dYjLOZY=
X-Received: by 2002:a17:90b:3ece:: with SMTP id rm14mr912273pjb.220.1643759962079;
 Tue, 01 Feb 2022 15:59:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298428430.3018233.16409089892707993289.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220201153154.jpyxayuulbhdran4@intel.com>
In-Reply-To: <20220201153154.jpyxayuulbhdran4@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 Feb 2022 15:59:15 -0800
Message-ID: <CAPcyv4ibSpq6VyyBmMA=DqsQTPMP7a+2hv4Uvq7cghpBh+Sjog@mail.gmail.com>
Subject: Re: [PATCH v3 31/40] cxl/memdev: Add numa_node attribute
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Tue, Feb 1, 2022 at 7:32 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 22-01-23 16:31:24, Dan Williams wrote:
> > While CXL memory targets will have their own memory target node,
> > individual memory devices may be affinitized like other PCI devices.
> > Emit that attribute for memdevs.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> This brings up an interesting question. Are all devices in a region affinitized
> to the same NUMA node? I think they must be - at which point, should this
> attribute be a part of a region, rather than a device?

This attribute is only here so that 'cxl list' can convey what CPU
node platform firmware might have affinitized the memory device. This
is for enumeration questions like, "how many memory devices are on
socket 0". The region NUMA node / affinity is wholly separate from
this number.
