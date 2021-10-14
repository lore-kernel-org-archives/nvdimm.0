Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E036B2C83
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 23:34:42 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id f21so5232324plb.3
        for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 16:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iq1R2vOoGCVjcZgn+ZMPcRorADbzRkujEOUqDJc96iY=;
        b=xo5QJjW09N1qV2nCHHYgp1+0XZR66iHmBcVmyPFi7Z1dviYqLxAk4KwsLSsnL1r497
         M4VAQ9D1OvZUV5cCryuBl0EejklT02/eaRU9LZffwO/n+0beq1tzSrCh2Oas+R5cQQys
         P3u4pi1pEJrFarhgdrKOXlvHpJPrSaBy3xCzCN+N7IuWIjlpTHxhKl7P3kTKA+BgXJMM
         HMGRyQOnsiagH+VC+g5ckdNOfM1JHfdoJ+nPbSlZ9GbMNHoqDuRv1VvVzWMzesLgRlTO
         77MhWzWYq98xqnGW7lbFF6OGUqnvoJ27H1hr5Gd1IX0dDXWOCEr6M0OhkpiyV3vOczDH
         eSug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iq1R2vOoGCVjcZgn+ZMPcRorADbzRkujEOUqDJc96iY=;
        b=DP1Bmb1ciRHfZeerxqawkTz81R/ZBGIqPDOQEkIQPrmOIC6rO9EwhIokLQLbvV+twi
         wNFywZEFtjsm4nzlSLYsXoAyQmL86qv7hKojFUUnOeT0WnbugxLbjCDyAkzde4XlBIOn
         7wEsJfvcEmwcpPrC56yR/UHV/GKqK/YHHnlpbMieXfRkxt624SEpqy+iqh5+WQoxmt29
         Os1syaBqzTzO+mOSIs4uC+VyxxKzG92dN0BvupRpnwKkBDujWSHXoDlLfdpr4duEsIEt
         2bIUpTmj7/zUnlXBSUpninJPD1Wdi6iA9jMBAauiJWpDmS57Lb4VtoXunhKYo05THbKc
         kf3g==
X-Gm-Message-State: AOAM530Z0lRwFFbeoaqbLQNLd6Nm4z1+H6A4P7Ki6MEsHzxK+55ljHaC
	kmwVuUxxeCIx1qHTLW3KaX57ZXLIAQN7JJ9mvfnR1A==
X-Google-Smtp-Source: ABdhPJwttEzIdgNzDfbtp1KIg9pF4rhju+Dgnns3/xrilIpBvJfL4X5BR5QSMc40MsVtGVVrpCmDntFg2LJhBgMYkQI=
X-Received: by 2002:a17:90b:350f:: with SMTP id ls15mr9525393pjb.220.1634254482497;
 Thu, 14 Oct 2021 16:34:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com> <20211007082139.3088615-17-vishal.l.verma@intel.com>
In-Reply-To: <20211007082139.3088615-17-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Oct 2021 16:34:32 -0700
Message-ID: <CAPcyv4g0V4JicoOfyiSB4LySB0sp=1hYMQYePu81PA9p9NOF5A@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 16/17] cxl-cli: add bash completion
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 7, 2021 at 1:22 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add bash completion for the cxl-cli commands implemented so far:
>   cxl-list
>   cxl-read-labels
>   cxl-write-labels
>   cxl-zero-labels

I'll take your word for it :)

Acked-by: Dan Williams <dan.j.williams@intel.com>
