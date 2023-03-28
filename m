Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E288BE0
	for <nvdimm@lists.linux.dev>; Tue, 28 Mar 2023 14:57:59 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id q7-20020a05600c46c700b003ef6e809574so4396222wmo.4
        for <nvdimm@lists.linux.dev>; Tue, 28 Mar 2023 07:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680015478;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DE5xgbwhRQpkJgfP8sEL5gZw3SNhWz8a/RrIbBfg2gk=;
        b=ogWMrlr7I27p4FwSejAr7Q2c1/kXf0NR8Ec5k4be40g439cNGZ3OUCBDTwj2+EJLBS
         +CVfoC11xm9nD86Y42TyBgqgb+BStWr/kyeLZir9gjK/HlHbgRrEkflNOaz65ZHPxbmi
         BtgH1xfl3hZvUenIpKCRqNlBc8BQ8gLlNyiclLGWqIKb6rooabZlKaaDAncJ6Tgy5Eh4
         0tz2uj+3IDTc6XqK5A0tMkM/SXWUDK687xJtClyW9GENsIrdj63nsd8OtjFVHRRcuOuB
         64pbM0vG8buKzrZ3TeB+Ax78GJoerauv979g8hang2NObPVtppPe4vv+cfBz9CvdK8dT
         ISuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680015478;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DE5xgbwhRQpkJgfP8sEL5gZw3SNhWz8a/RrIbBfg2gk=;
        b=i+AY5o7u6ArIy/pS9qp3aYXjju71wx12Gu7LsyzWmz9h5u7jwk/+Vjv+Guuiv0/u4E
         aBqBHtWkZomsGFMUsNcMZ7LiagguCcndlB0lynDRN001nBa7dltlMmG9sDiAXHcEoU0/
         RpvUXvkSq5dikrU42Ub8q4VwFDVSGnaOlzh7KI3zdXCQ2um6Zg7NWbnDzuJCZz4QtFPd
         U2DJzs/HoFi2SwoSmcy0kn0mO6selg+Zx7b2wCQVF+qccnhZwP5dKHc4NlvMB14egwzD
         Hw+Bq11wH2hm69hGNIXrehlwVfu+PfXNHNzuXhQ/6C8OAIfoP0U3lUz3GjrWKQ3/C9LI
         PGJQ==
X-Gm-Message-State: AO0yUKX8IOuEmWy2zrA4nWz/vznrxp3PsfcqvTyhXOiC5P26P3u44UUI
	ZpGTpoax6BD+YLoKJLmbC+o=
X-Google-Smtp-Source: AK7set/I8CH/86E0q7PQNOZAnX2C+ynZld6z0EVam7znB2FfZDfuDS4nv55P+mN8t5DQ9YTt9sfnew==
X-Received: by 2002:a05:600c:21da:b0:3ed:346d:452f with SMTP id x26-20020a05600c21da00b003ed346d452fmr13068122wmj.26.1680015477838;
        Tue, 28 Mar 2023 07:57:57 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id m15-20020a05600c3b0f00b003ee91eda67bsm12949511wms.12.2023.03.28.07.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 07:57:57 -0700 (PDT)
Date: Tue, 28 Mar 2023 17:57:54 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org, kernel-janitors@vger.kernel.org,
	cip-dev <cip-dev@lists.cip-project.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH v2] ACPI: NFIT: prevent underflow in acpi_nfit_ctl()
Message-ID: <ad63258f-cc13-4f6c-a2a7-aea783f60931@kili.mountain>
References: <Y8ldQn1v4r5i5WLX@kadam>
 <x49y1py5wcd.fsf@segfault.boston.devel.redhat.com>
 <Y8ok/oCxzOhFDEQ+@kadam>
 <8a425108-3480-4a58-ba4f-727146a0cef7@kili.mountain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a425108-3480-4a58-ba4f-727146a0cef7@kili.mountain>

On Tue, Mar 28, 2023 at 05:55:40PM +0300, Dan Carpenter wrote:
> On Fri, Jan 20, 2023 at 08:22:06AM +0300, Dan Carpenter wrote:
> > On Thu, Jan 19, 2023 at 11:21:22AM -0500, Jeff Moyer wrote:
> > > Dan Carpenter <error27@gmail.com> writes:
> > > 
> > > > The concern here would be that "family" is negative and we pass a
> > > > negative value to test_bit() resulting in an out of bounds read
> > > > and potentially a crash.
> > > 
> > > I don't see how this can happen.  Do you have a particular scenario in
> > > mind?
> > > 
> > 
> > This is from static analysis.  My main thinking was:
> > 
> > 1) The static checker says that this comes from the user.
> > 2) Every upper bounds check should have a lower bounds check.
> > 3) family is passed to array_index_nospec() so we must not trust it.
> > 
> > But looking closer today here is what the checker is concerned about:
> > 
> > 	func = cmd_to_func(nfit_mem, cmd, call_pkg, &family);
> > 
> > Assume "nfit_mem" is NULL but "call_pkg" is non NULL (user input from
> > __nd_ioctl() or ars_get_status().  In that case family is unchecked user
> > input.
> > 
> > But probably, it's not possible for nfit_mem to be NULL in those caller
> > functions?
> 
> Did we ever figure out if it's possible for nfit_mem to be NULL?

Another idea is I could send this patch as a static checker fix instead
of a security vulnerability.  That way we would be safe going forward
regardless.

regards,
dan carpenter

