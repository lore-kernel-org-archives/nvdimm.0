Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D147712B8A
	for <nvdimm@lists.linux.dev>; Thu, 17 Aug 2023 14:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692282394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xSwgi5nYOBKBG7F7dJg6g/1QY293MG0NVMQDEeBbj4I=;
	b=arw4f6MqzF6A1o4gRJrwjMqmK+IlNwekyHvAyspvQzlN9Tqluq1vfJpspOiNbdaS6+csy0
	52SA33keyitBiPDHN8UgoGES43V5k7WSMFSC0OoAl0CCi4um2Q9kllQk1vM5etIUqfEoWX
	iMZIOu7VcAv3SzwoqHCfUDL8AYLZ/ds=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-zvqiTbbjOpm7aV8XX542Tw-1; Thu, 17 Aug 2023 10:26:32 -0400
X-MC-Unique: zvqiTbbjOpm7aV8XX542Tw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 366491C07842;
	Thu, 17 Aug 2023 14:26:32 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E9F27140E950;
	Thu, 17 Aug 2023 14:26:31 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc: <dan.j.williams@intel.com>,  <vishal.l.verma@intel.com>,  <dave.jiang@intel.com>,  <ira.weiny@intel.com>,  <nvdimm@lists.linux.dev>,  <linux-kernel@vger.kernel.org>,  <yusongping@huawei.com>,  <artem.kuzin@huawei.com>
Subject: Re: [PATCH] drivers: nvdimm: fix memleak
References: <20230817115945.771826-1-konstantin.meskhidze@huawei.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Thu, 17 Aug 2023 10:32:19 -0400
In-Reply-To: <20230817115945.771826-1-konstantin.meskhidze@huawei.com>
	(Konstantin Meskhidze's message of "Thu, 17 Aug 2023 19:59:45 +0800")
Message-ID: <x49fs4hu4cs.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7

Konstantin Meskhidze <konstantin.meskhidze@huawei.com> writes:

> Memory pointed by 'nd_pmu->pmu.attr_groups' is allocated in function
> 'register_nvdimm_pmu' and is lost after 'kfree(nd_pmu)' call in function
> 'unregister_nvdimm_pmu'.
>
> Co-developed-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
>  drivers/nvdimm/nd_perf.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/nvdimm/nd_perf.c b/drivers/nvdimm/nd_perf.c
> index 433bbb68a..14881c4e0 100644
> --- a/drivers/nvdimm/nd_perf.c
> +++ b/drivers/nvdimm/nd_perf.c
> @@ -323,7 +323,8 @@ EXPORT_SYMBOL_GPL(register_nvdimm_pmu);
>  void unregister_nvdimm_pmu(struct nvdimm_pmu *nd_pmu)
>  {
>  	perf_pmu_unregister(&nd_pmu->pmu);
>  	nvdimm_pmu_free_hotplug_memory(nd_pmu);
> +	kfree(nd_pmu->pmu.attr_groups);
>  	kfree(nd_pmu);
>  }
>  EXPORT_SYMBOL_GPL(unregister_nvdimm_pmu);

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

