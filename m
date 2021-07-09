Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2378970
	for <nvdimm@lists.linux.dev>; Fri,  9 Jul 2021 19:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1625858439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B6JFzXEkxCbG1tHoiHiMI3vVDGlruXBfOWWbTfVaO+k=;
	b=cQst4Epxowgx9jhUd8JM88//5NmjAgsSHkT0QXiazCtbKVqcDvbku7RF2mpPMN5+aT4MIP
	AkyrQD6m+YEMXBwHIFfdf9LD+QyQS0hcrCh8Ubt61pVUfH5SbtRoOvHmogCRyfkrBTWxu+
	E6w12ABdt2yTks8bMRER7Gvo/PR1h08=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-IpPFnkSOOwupq7N9kaL33g-1; Fri, 09 Jul 2021 15:20:36 -0400
X-MC-Unique: IpPFnkSOOwupq7N9kaL33g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41AA1102CB2E;
	Fri,  9 Jul 2021 19:20:35 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FD77100EB3D;
	Fri,  9 Jul 2021 19:20:33 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Adam Borowski <kilobyte@angband.pl>,  James Anandraj
 <james.sushanth.anandraj@intel.com>,  Linux NVDIMM
 <nvdimm@lists.linux.dev>,  Michal =?utf-8?Q?Such=C3=A1nek?=
 <msuchanek@suse.de>, bgurney@redhat.com
Subject: Re: [PATCH v1 0/4] ndctl: Add pcdctl tool with pcdctl list and reconfigure-region commands
References: <20210708183741.2952-1-james.sushanth.anandraj@intel.com>
	<CAPcyv4iQqL7dGxgN_pSR0Gu27DXX4-d6SNhi2nUs38Mrq+jB=Q@mail.gmail.com>
	<YOg/vKafc5PJf/GE@angband.pl>
	<CAPcyv4jVvr0zBvf4_yf4KGB2CYLX4h_NczM0g+so8EOiL8CyEQ@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Fri, 09 Jul 2021 15:21:59 -0400
In-Reply-To: <CAPcyv4jVvr0zBvf4_yf4KGB2CYLX4h_NczM0g+so8EOiL8CyEQ@mail.gmail.com>
	(Dan Williams's message of "Fri, 9 Jul 2021 12:01:28 -0700")
Message-ID: <x495yxjz414.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jmoyer@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Dan Williams <dan.j.williams@intel.com> writes:

> On Fri, Jul 9, 2021 at 5:23 AM Adam Borowski <kilobyte@angband.pl> wrote:
>>
>> On Thu, Jul 08, 2021 at 02:24:04PM -0700, Dan Williams wrote:
>> > [ add Jeff, Michal, and Adam ]
>> >
>> > Hey ndctl distro maintainers,
>> >
>> > Just wanted to highlight this new tool submission for your
>> > consideration. The goal here is to have a Linux native provisioning
>> > tool that covers the basics of the functionality that is outside of
>> > the ACPI specification, and reduce the need for ipmctl outside of
>> > exceptional device-specific debug scenarios. [...]
>>
>> > I will note that CXL moves the region configuration into the base CXL
>> > specification so the ndctl project will pick up a "cxl-cli" tool for
>> > that purpose. [...]
>>
>> > Please comment on its suitability for shipping in distros alongside
>> > the ndctl tool.
>>
>> I see no issues with that.
>>
>> You might want to suggest whether you prefer pcdctl and clx-cli to be
>> shipped in a separate binary package.
>
> Yes, that was my expectation that ndctl, daxctl, pcdctl (ipmregion?),
> and the 'cxl' tool would each be independent binary packages.

Agreed.  We would only build and ship a particular tool on the platforms
that supported it.

Cheers,
Jeff

