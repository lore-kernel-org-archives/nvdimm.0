Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D6430CFD
	for <nvdimm@lists.linux.dev>; Tue,  7 Nov 2023 17:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FE5pGXR6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699378130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4VPZFmxOTdK0f+xDDudu8FadGufVVmWSRZvomdbfYm0=;
	b=FE5pGXR6lilkg4SIAzKdzDH7RU5WRTHU+VJL9IDZOdE1rdniOSgw95WhtAnwTrHEHoDupI
	P5i+JrIvLO6QjTHZvvM1oZVlMuWrv1D36bfW6X36ex6W0ON5nhrAVdFgTiy6CpuGAApf6e
	595JzKlVj11kBDEYLk4TP0d7ur7q2yk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-3v7CgNyCOeCKAnScROdgSQ-1; Tue, 07 Nov 2023 12:28:47 -0500
X-MC-Unique: 3v7CgNyCOeCKAnScROdgSQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFCF0185A782;
	Tue,  7 Nov 2023 17:28:46 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.8.211])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 88E4C40C6EBB;
	Tue,  7 Nov 2023 17:28:46 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev,  Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH ndctl] ndctl.spec.in: Use SPDX identifiers in License
 fields
References: <20231026-spec_license_fix-v1-1-45e4c7866cd3@intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Tue, 07 Nov 2023 12:28:46 -0500
In-Reply-To: <20231026-spec_license_fix-v1-1-45e4c7866cd3@intel.com> (Vishal
	Verma's message of "Thu, 26 Oct 2023 13:04:19 -0600")
Message-ID: <x49bkc5wjzl.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Vishal Verma <vishal.l.verma@intel.com> writes:

> There's a push to use SPDX license IDs in .spec files:
>   https://docs.fedoraproject.org/en-US/legal/update-existing-packages/
>
> Update the various License: fields in the spec to conform to this.

Thanks, Vishal!

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Jeff Moyer <jmoyer@redhat.com>
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2243847
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl.spec.in | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index 7702f95..cb9cb6f 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -2,7 +2,7 @@ Name:		ndctl
>  Version:	VERSION
>  Release:	1%{?dist}
>  Summary:	Manage "libnvdimm" subsystem devices (Non-volatile Memory)
> -License:	GPLv2
> +License:	GPL-2.0-only and LGPL-2.1-only and CC0-1.0 and MIT
>  Url:		https://github.com/pmem/ndctl
>  Source0:	https://github.com/pmem/%{name}/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz
>  
> @@ -48,7 +48,7 @@ Firmware Interface Table).
>  
>  %package -n DNAME
>  Summary:	Development files for libndctl
> -License:	LGPLv2
> +License:	LGPL-2.1-only
>  Requires:	LNAME%{?_isa} = %{version}-%{release}
>  
>  %description -n DNAME
> @@ -57,7 +57,7 @@ developing applications that use %{name}.
>  
>  %package -n daxctl
>  Summary:	Manage Device-DAX instances
> -License:	GPLv2
> +License:	GPL-2.0-only
>  Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
>  
>  %description -n daxctl
> @@ -68,7 +68,7 @@ filesystem.
>  
>  %package -n cxl-cli
>  Summary:	Manage CXL devices
> -License:	GPLv2
> +License:	GPL-2.0-only
>  Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
>  
>  %description -n cxl-cli
> @@ -77,7 +77,7 @@ the Linux kernel CXL devices.
>  
>  %package -n CXL_DNAME
>  Summary:	Development files for libcxl
> -License:	LGPLv2
> +License:	LGPL-2.1-only
>  Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
>  
>  %description -n CXL_DNAME
> @@ -86,7 +86,7 @@ that use libcxl, a library for enumerating and communicating with CXL devices.
>  
>  %package -n DAX_DNAME
>  Summary:	Development files for libdaxctl
> -License:	LGPLv2
> +License:	LGPL-2.1-only
>  Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
>  
>  %description -n DAX_DNAME
> @@ -98,7 +98,7 @@ mappings of performance / feature-differentiated memory.
>  
>  %package -n LNAME
>  Summary:	Management library for "libnvdimm" subsystem devices (Non-volatile Memory)
> -License:	LGPLv2
> +License:	LGPL-2.1-only and CC0-1.0 and MIT
>  Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
>  
>  
> @@ -107,7 +107,7 @@ Libraries for %{name}.
>  
>  %package -n DAX_LNAME
>  Summary:	Management library for "Device DAX" devices
> -License:	LGPLv2
> +License:	LGPL-2.1-only and CC0-1.0 and MIT
>  
>  %description -n DAX_LNAME
>  Device DAX is a facility for establishing DAX mappings of performance /
> @@ -116,7 +116,7 @@ control API for these devices.
>  
>  %package -n CXL_LNAME
>  Summary:	Management library for CXL devices
> -License:	LGPLv2
> +License:	LGPL-2.1-only and CC0-1.0 and MIT
>  
>  %description -n CXL_LNAME
>  libcxl is a library for enumerating and communicating with CXL devices.
>
> ---
> base-commit: d32dc015ad5b18fc37d3d7f10dd1f0a5442d3b7c
> change-id: 20231026-spec_license_fix-cfe7c9bf1a0f
>
> Best regards,

