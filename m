Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D3C613F
	for <nvdimm@lists.linux.dev>; Thu, 15 Dec 2022 21:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671138875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TeJPV/gu6ddNxnYkabgVMHopuQa+A5a3mQxxM4gOxsY=;
	b=P33K+2ZaomgVTF0vk19b6TtPOW2HW+w8dORK2cbwOf2ZdgQa1E5PHWYHoqGXegy4dG4AkK
	FrWImnpexOxcU9T8iZmxlBP7sGylLG69yZdXeUh2JHCevoEfh8FaozoKwuG8ev9NO3bflO
	JONMTzHlgWfz79N8Tj/CWW00coCzozc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131--rWG-2kVO2eeFp9YABJG_Q-1; Thu, 15 Dec 2022 16:14:32 -0500
X-MC-Unique: -rWG-2kVO2eeFp9YABJG_Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 278B3811E6E;
	Thu, 15 Dec 2022 21:14:32 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 00C1F2026D68;
	Thu, 15 Dec 2022 21:14:31 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>,  <linux-cxl@vger.kernel.org>,  <nvdimm@lists.linux.dev>,  <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2 1/4] ndctl: add CXL bus detection
References: <167105505204.3034751.8113387624258581781.stgit@djiang5-desk3.ch.intel.com>
	<167105522584.3034751.8329537593759406601.stgit@djiang5-desk3.ch.intel.com>
	<639b85df2197a_b05d1294fb@dwillia2-xfh.jf.intel.com.notmuch>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Thu, 15 Dec 2022 16:18:24 -0500
In-Reply-To: <639b85df2197a_b05d1294fb@dwillia2-xfh.jf.intel.com.notmuch> (Dan
	Williams's message of "Thu, 15 Dec 2022 12:38:55 -0800")
Message-ID: <x49r0x0xt5r.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Dan Williams <dan.j.williams@intel.com> writes:

> Dave Jiang wrote:
>> Add a CXL bus type, and detect whether a 'dimm' is backed by the CXL
>> subsystem.
>> 
>> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> 
>> ---
>> v2:
>> - Improve commit log. (Vishal)
>> ---
>>  ndctl/lib/libndctl.c   |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  ndctl/lib/libndctl.sym |    1 +
>>  ndctl/lib/private.h    |    1 +
>>  ndctl/libndctl.h       |    1 +
>>  4 files changed, 56 insertions(+)
>> 
>> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
>> index ad54f0626510..10422e24d38b 100644
>> --- a/ndctl/lib/libndctl.c
>> +++ b/ndctl/lib/libndctl.c
>> @@ -12,6 +12,7 @@
>>  #include <ctype.h>
>>  #include <fcntl.h>
>>  #include <dirent.h>
>> +#include <libgen.h>
>
> This new include had me looking for why below...

man 3 basename

>>  #include <sys/stat.h>
>>  #include <sys/types.h>
>>  #include <sys/ioctl.h>
>> @@ -876,6 +877,48 @@ static enum ndctl_fwa_method fwa_method_to_method(const char *fwa_method)
>>  	return NDCTL_FWA_METHOD_RESET;
>>  }
>>  
>> +static int is_ndbus_cxl(const char *ctl_base)
>> +{
>> +	char *path, *ppath, *subsys;
>> +	char tmp_path[PATH_MAX];
>> +	int rc;
>> +
>> +	/* get the real path of ctl_base */
>> +	path = realpath(ctl_base, NULL);
>> +	if (!path)
>> +		return -errno;
>> +
>> +	/* setup to get the nd bridge device backing the ctl */
>> +	sprintf(tmp_path, "%s/device", path);
>> +	free(path);
>> +
>> +	path = realpath(tmp_path, NULL);
>> +	if (!path)
>> +		return -errno;
>> +
>> +	/* get the parent dir of the ndbus, which should be the nvdimm-bridge */
>> +	ppath = dirname(path);
>> +
>> +	/* setup to get the subsystem of the nvdimm-bridge */
>> +	sprintf(tmp_path, "%s/%s", ppath, "subsystem");
>> +	free(path);
>> +
>> +	path = realpath(tmp_path, NULL);
>> +	if (!path)
>> +		return -errno;
>> +
>> +	subsys = basename(path);
>> +
>> +	/* check if subsystem is cxl */
>> +	if (!strcmp(subsys, "cxl"))
>> +		rc = 1;
>> +	else
>> +		rc = 0;
>> +
>> +	free(path);
>> +	return rc;
>> +}
>> +
>>  static void *add_bus(void *parent, int id, const char *ctl_base)
>>  {
>>  	char buf[SYSFS_ATTR_SIZE];
>> @@ -919,6 +962,11 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>>  	else
>>  		bus->has_of_node = 1;
>>  
>> +	if (is_ndbus_cxl(ctl_base))
>> +		bus->has_cxl = 1;
>> +	else
>> +		bus->has_cxl = 0;
>> +
>
> I think you can drop is_ndbus_cxl() and just do this:
>
> @@ -981,6 +976,11 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>         if (!bus->provider)
>                 goto err_read;
>  
> +       if (strcasestr("cxl", provider))
> +               bus->has_cxl = 1;
> +       else
> +               bus->has_cxl = 0;
> +

Can you explain why this is preferred?

Cheers,
Jeff

