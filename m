Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794C868
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 21:56:06 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id p17so9138575pgj.2
        for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 13:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PF+Db0UtQ07kU5lBc+mvHyAIrkndth9X28SjtsBN2FU=;
        b=NWFsJ1cNnED05crH2nhDwDg9KE/4G4rZ3rmGqPP8USOGUu+SMZy5Ur1LXx0PEKElxV
         nfdapYM4U10BWU+Jw9w4/VgJ3MN1fRz4CYqSf1RUSOkn5627t44ZvIcTfqpxvhBO6//d
         lo6BIpLL0jyQ5ELRlAv7mo+mjvxHPqjj8j4xzW8/l9q7ktam1RAEesyVZQvTAyqX7Ail
         312Iq+1dqn0FnUFKwJuAzCcvPLIVBV58+HFqfQiidxaZEvgIBQFRZ2nCgGljur+Rl96z
         enuw1VAh9agdEP6w81YgqHmZjT5t/GlMVO9VjzcFe9ZwsPkLkUXJkgfbiZbql7K/lVj9
         d9gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PF+Db0UtQ07kU5lBc+mvHyAIrkndth9X28SjtsBN2FU=;
        b=2cCuFoSQ021/B5JpRUsglVDDSzB4XUFI6leM+a0v0AnBvJtuEspJAKNb7CPrrKIUiO
         ojVXoQooN/IPe4olLxYlXn1mHMQwUnSglOZpwi4t6ek0z9od+XCTZkV28l5VGY/UmIns
         Gsd+wRHOHxGHRyP75K9EZHTlk61MOvqeruBARg2PmgIOq7AbrPldTTUkFCOfhEy+TPwY
         c1vRaxRCxO0iMK5iPFeVCo7+fgPT8PqEfHuF+4VtJTVhdoEeiqYLkRtwHsnREpnnj01G
         cySKExWnyrApl0vCT3EX70pHgKlz8wY4G39lFahm9N03YyKlGn0Yy8KU8aNo6qcl8UtF
         4iKg==
X-Gm-Message-State: AOAM532rLOjCj6+7hhBbr2mQLrB4tFXoRLTq8bMvVYEYDTE0/BrF9oHV
	vRMKnLj6yX85iJKUwHzssWYF8MiDfBx6rYJ9ywyT7Q==
X-Google-Smtp-Source: ABdhPJwyFEuWJkyEb/ZMBQPQv1yoWJGWauAD6tOdiPAxiHJjmDtKMcqoMWcJc7toKxRWEaqhGl0IRUGpvGcQ6AIoMl0=
X-Received: by 2002:a63:584e:: with SMTP id i14mr7003745pgm.356.1636754166029;
 Fri, 12 Nov 2021 13:56:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211111204436.1560365-17-vishal.l.verma@intel.com> <20211112215245.1887356-1-vishal.l.verma@intel.com>
In-Reply-To: <20211112215245.1887356-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Nov 2021 13:55:54 -0800
Message-ID: <CAPcyv4iROggvmHV-AqagQ6uMoYOuBs=OZ0mv0eYa3-2H+VYODA@mail.gmail.com>
Subject: Re: [ndctl PATCH v6 16/16] cxl: add health information to cxl-list
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 12, 2021 at 1:52 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add JSON output for fields from the 'GET_HEALTH_INFO' mailbox command
> to memory device listings.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
