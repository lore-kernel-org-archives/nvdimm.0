Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E9317C8
	for <nvdimm@lists.linux.dev>; Fri, 20 Jan 2023 05:22:11 +0000 (UTC)
Received: by mail-wm1-f51.google.com with SMTP id m15so3156444wms.4
        for <nvdimm@lists.linux.dev>; Thu, 19 Jan 2023 21:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPUNBOEvi+EfT+XJWJvekQT2sNWEjQ5PxX/U+WoCuzc=;
        b=YBIwhB603yUqIdel1BN1aQ2kRRXRXqB2ePnBo3AkabEKkIGyDyo6TflF9PCi7R+hXF
         uM7KoCMnU6bNghykefMWau8xbi8kmQEoq0eKHop8Onk0DBVr0FMBryV2/DhXMkUxVxyW
         +25pM8oejnfFKv2WQMqpFfhuNf+U+R7cRkBTKzRS9Ng0t/RojLDy6qWw6EkKgyf4PkPT
         B2XYSyWpzPB9g9N21dEcnHRVUJwkRPSEsgEo5PUsnNMF1+YfJkhVuxfLSEFilB4J2Mtk
         EohULOeh+ymbakO1zDxwI+oXnMV/seI/uIkLI/7sPHX5TxRBoO190pVfz9VszRXppNYv
         aKXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZPUNBOEvi+EfT+XJWJvekQT2sNWEjQ5PxX/U+WoCuzc=;
        b=pdnPKzaHFSKLsbnEH94kXdP/KkcrfE+fefxWtdXJltTPLUExlZIwGCA2wKZdWSGMjr
         1JKCcmVq9DGcpO4I7+lezkGEEJg/yTgAB8lin7VD3Fbm5bByHaq21a4PsoksBeZcFFR1
         alaUBsNZs5Ez8Anc2/ZoH9ipL9Sh8n8Zj7S2YfkIo/Kw9IFQaw/xSiz9LUU+lA8mXITh
         J0SulFrIVDbO5H/yT4x0YibDBMe+bORJmKTL+OnKtWnIB4NKMcZH8ArEfwgqe+LFKctg
         kTtvbn+VTXqkfdRWo82m3UFMVquiERCuF2KlAEbMd/CGlOQwK6AEtr+JjDN0J0c0v+Yn
         RrEw==
X-Gm-Message-State: AFqh2kqYyba9PVkP4lsCKXtBeSXwg7a8RS005RjI3CnzR7BJc7dLV9bR
	8P7/4Gyma6KLQbZAfS3yhQM=
X-Google-Smtp-Source: AMrXdXvzl4+RN1WjgYUz4tRPCvty5ZKlP8ibxlgMTYBueXvwytqo0rr34srYHacHIL0AlSzaowxE1A==
X-Received: by 2002:a05:600c:3b1b:b0:3da:11d7:dba3 with SMTP id m27-20020a05600c3b1b00b003da11d7dba3mr12497450wms.5.1674192129466;
        Thu, 19 Jan 2023 21:22:09 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id k16-20020a05600c0b5000b003db0a08694bsm1118757wmr.8.2023.01.19.21.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 21:22:09 -0800 (PST)
Date: Fri, 20 Jan 2023 08:22:06 +0300
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
Message-ID: <Y8ok/oCxzOhFDEQ+@kadam>
References: <Y8ldQn1v4r5i5WLX@kadam>
 <x49y1py5wcd.fsf@segfault.boston.devel.redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49y1py5wcd.fsf@segfault.boston.devel.redhat.com>

On Thu, Jan 19, 2023 at 11:21:22AM -0500, Jeff Moyer wrote:
> Dan Carpenter <error27@gmail.com> writes:
> 
> > The concern here would be that "family" is negative and we pass a
> > negative value to test_bit() resulting in an out of bounds read
> > and potentially a crash.
> 
> I don't see how this can happen.  Do you have a particular scenario in
> mind?
> 

This is from static analysis.  My main thinking was:

1) The static checker says that this comes from the user.
2) Every upper bounds check should have a lower bounds check.
3) family is passed to array_index_nospec() so we must not trust it.

But looking closer today here is what the checker is concerned about:

	func = cmd_to_func(nfit_mem, cmd, call_pkg, &family);

Assume "nfit_mem" is NULL but "call_pkg" is non NULL (user input from
__nd_ioctl() or ars_get_status().  In that case family is unchecked user
input.

But probably, it's not possible for nfit_mem to be NULL in those caller
functions?

regards,
dan carpenter

