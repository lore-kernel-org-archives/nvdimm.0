Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297BA2CA6
	for <nvdimm@lists.linux.dev>; Thu, 16 Dec 2021 21:42:55 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id e17so116598plh.8
        for <nvdimm@lists.linux.dev>; Thu, 16 Dec 2021 13:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cQVeVWU9oA4d3CXlghCMlJitW2bEA58vYcUtDB3M1Eo=;
        b=f7N6DhGAey1dvvJH9N0sqmsvVaBOJfh+F/pi827mS9bBRNLTZ7pVY4ebvpvYX+bNqK
         LOT9R1E1XIpCGe+9Ec+kJdxT+mz4mRsl8EOl1JmevQkOaPqjxNuluwr31fM4OpROFkd2
         R9yyM7KS2Sx5ynj/AQQTxuahm+0W3WlIiK0mGlUc+RrqJsWxs9Ab4dl7TmCAzSfP01Lk
         vAJ/lim2Lj/ONnDMGgfFfYjF4KikstPg5AUr/kUld+NAa7iKhTKcz1nF/cvyNEsq5B2G
         elooGb2j9R4pUOdK+3BSfRB/zvSXlCIEprDckBrsCD5HsuFqIF4HrJi1QtCgB8D/1iy0
         EZvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cQVeVWU9oA4d3CXlghCMlJitW2bEA58vYcUtDB3M1Eo=;
        b=BIOmuOxlrY6ejy8SG4nKtO5oyWIghH40dxRHAThnvWp/+YWv0qZr3YvsXTODl0XWrm
         yZiZYAzCJLrXX09+a8CkQ8KdZW63oxFN4dOyITnDDG1TCT4DbTclDBwxfpyuLEqGlIsb
         K90cKm1zLNvU9n5ywWNWYA162KbvbL3NdjQ4piLDH+0w7TiJIY+0BCFsiceqyPth3wgk
         wATsiA37yhiVnyIDaYNZmQRLxIzQA0+rVVJwnWyLWKyPRLxWXDju/+FeeJjayKwcvnPO
         Exo1riWoFoaz6zQI1sksnZkRgxh6b2XNmoY00mxXAfwVJcuAnbq8pZOSuhfKxuoQpIR7
         WTIA==
X-Gm-Message-State: AOAM5319OpMLjXBK5P+R13G5LiHufV+nStx/6s8FNNuorZEMswjj6f1i
	1QKCBKMuGjQRJ2drOtOMkTDa+636C19kFpcsDgGBhQ==
X-Google-Smtp-Source: ABdhPJzlqo161UByxDLElKvsOBIO6C6ADy+5aY+f9JsLekq7YMQPcbtDWctAwuT4e2icTl4Eyy1F0xtSF8mRaqcuSi4=
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr51217pjb.220.1639690975486;
 Thu, 16 Dec 2021 13:42:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211210223440.3946603-1-vishal.l.verma@intel.com> <20211210223440.3946603-2-vishal.l.verma@intel.com>
In-Reply-To: <20211210223440.3946603-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Dec 2021 13:42:44 -0800
Message-ID: <CAPcyv4g=jfpUQ1h09MXdDy+t7Ur3ynPP0XurSfOM7gzUPbYYpg@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 01/11] ndctl, util: add parse-configs helper
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 10, 2021 at 2:34 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> From: QI Fuli <qi.fuli@fujitsu.com>
>
> Add parse-config util to help ndctl commands parse ndctl global
> configuration files. This provides a parse_configs_prefix() helper which
> uses the iniparser APIs to read all applicable config files, and either
> return a 'value' for a requested 'key', or perform a callback if
> requested. The operation is defined by a 'struct config' which
> encapsulates the key to search for, the location to store the value, and
> any callbacks to be executed.
>
> Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
[..]
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index a63b1e0..afdd03c 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -56,7 +56,8 @@ ndctl_LDADD =\
>         ../libutil.a \
>         $(UUID_LIBS) \
>         $(KMOD_LIBS) \
> -       $(JSON_LIBS)
> +       $(JSON_LIBS) \
> +       -liniparser

Darn, no pkgconfig for iniparser. Oh well.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
