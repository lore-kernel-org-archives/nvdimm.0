Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD092FB6
	for <nvdimm@lists.linux.dev>; Tue, 18 May 2021 22:42:27 +0000 (UTC)
Received: by mail-ed1-f43.google.com with SMTP id t3so13073082edc.7
        for <nvdimm@lists.linux.dev>; Tue, 18 May 2021 15:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zu5GK23yJ6L2kBBaFGsagM6qn5wup77XOxyPy2gcO30=;
        b=K2swg+0EwseRLo3YyioxVuLG8XPm9IOxG27qagUePeT89zLlH37Uy42oTxb1aJDqIa
         5ioIxJX+I8oNwuN9b9gqg4y8fXOc8iBjc21MC/JWyi9KvE9Y+J9oFe3LJAHKcHDU65Wz
         6idsEByWRi1JyWyHAQ+ejXOb/ZHFuLwR2Qc9y8l8QUIoq9g+UJIClAUwl3Vau95oSkEm
         NdjcK9M6sbHZcm96FiE19Oo+uBgBru9/YD1zJweNaK+pPm8BB8Pn2ruMgdgetMpMtskR
         1hcSlC4yk3xESxBUwjbQ62cN7wqRMHAVpBHeLYu6bqIHNkJpn5+bhAlBqbm9D9H1ir3f
         9TwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zu5GK23yJ6L2kBBaFGsagM6qn5wup77XOxyPy2gcO30=;
        b=pO1md6O4TZ3SrQhjB1CNO0oXaYH/zTQrFPjfXH+BDxfixgaVrKBm2s3GqKCfN4QWqN
         OioVT7DVz033hdxOJqHQ7A8fgqBH4DRZgVvV/U6AgvzXmDHUtMzU0wI5AXiMokwoodJN
         mn30MQbnLFfgMvWj/tJYE7GbYphih+W7+mzvt7kDPxsB0zfyVMwfmt6IddUlKIbRaQw1
         WN2QtyJAk364WNzgjPV9T+2BwIr9pn+9kPCwEJpTDCUt3HGcQpWMLHZqLvC+EJCMs2dX
         40PlsDQhS2aaj2nLNX0kuwx7h3lKyq+Nwf537b/SHbsZF07Y6ZRTIz/HPuCtaL3bIgRR
         dvaw==
X-Gm-Message-State: AOAM533uaKcmeMtp/1LV2vfiB+4O7CIno+sVM7M0/leBUMWGgwymSWEd
	s0rTx1hXKCy67WOeC5RCAb/8FUcXlEL6APupE5MMPb0OqQE=
X-Google-Smtp-Source: ABdhPJwSMNlakbf8hXUcE8GgwcgbPtYipaMyEu+Yx5fwcdC5pngMIqdnrYpBXKZ7FXVntdj1wiDkYqaQmcCmCpyno9w=
X-Received: by 2002:a50:fe8e:: with SMTP id d14mr9583314edt.97.1621377746185;
 Tue, 18 May 2021 15:42:26 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210518222527.550730-1-vishal.l.verma@intel.com>
In-Reply-To: <20210518222527.550730-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 18 May 2021 15:42:14 -0700
Message-ID: <CAPcyv4hfZBgtEW8iaJ1yu=E758hzErxiAre2Tk4cw7Fb0E=R=Q@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: Update nvdimm mailing list address
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, May 18, 2021 at 3:26 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The 'nvdimm' mailing list has moved from lists.01.org to
> lists.linux.dev. Update CONTRIBUTING.md and configure.ac to reflect
> this.

LGTM

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
