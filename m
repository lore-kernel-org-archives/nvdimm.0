Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF72F639
	for <nvdimm@lists.linux.dev>; Tue, 29 Nov 2022 05:22:56 +0000 (UTC)
Received: from smtpclient.apple (c-24-62-201-179.hsd1.ma.comcast.net [24.62.201.179])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id 79307401AF67;
	Tue, 29 Nov 2022 00:22:55 -0500 (EST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Eliot Moss <moss@roc.cs.umass.edu>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: nvdimm,pmem: makedumpfile: __vtop4_x86_64: Can't get a valid pte.
Date: Tue, 29 Nov 2022 00:22:44 -0500
Message-Id: <70F971CF-1A96-4D87-B70C-B971C2A1747C@roc.cs.umass.edu>
References: <bd310eeb-7da1-ffe5-a25e-b4871ff3485d@fujitsu.com>
Cc: Moss@cs.umass.edu, kexec@lists.infradead.org, linux-mm@kvack.org,
 nvdimm@lists.linux.dev, dan.j.williams@intel.com
In-Reply-To: <bd310eeb-7da1-ffe5-a25e-b4871ff3485d@fujitsu.com>
To: lizhijian@fujitsu.com
X-Mailer: iPhone Mail (20B101)

Glad you found it. Any thoughts/reactions?  EM

Sent from my iPhone

> On Nov 29, 2022, at 12:17 AM, lizhijian@fujitsu.com wrote:
>=20
> =EF=BB=BF
>=20
>> On 28/11/2022 23:03, Eliot Moss wrote:
>>> On 11/28/2022 9:46 AM, lizhijian@fujitsu.com wrote:
>>>=20
>>>=20
>>> On 28/11/2022 20:53, Eliot Moss wrote:
>>>> On 11/28/2022 7:04 AM, lizhijian@fujitsu.com wrote:
>>>>> Hi folks,
>>>>>=20
>>>>> I'm going to make crash coredump support pmem region. So
>>>>> I have modified kexec-tools to add pmem region to PT_LOAD of vmcore.
>>>>>=20
>>>>> But it failed at makedumpfile, log are as following:
>>>>>=20
>>>>> In my environment, i found the last 512 pages in pmem region will caus=
e the error.
>>>>=20
>>>> I wonder if an issue I reported is related: when set up to map
>>>> 2Mb (huge) pages, the last 2Mb of a large region got mapped as
>>>> 4Kb pages, and then later, half of a large region was treated
>>>> that way.
>>>>=20
>>> Could you share the url/link ? I'd like to take a look
>>=20
>> It was in a previous email to the nvdimm list.  the title was:
>>=20
>> "Possible PMD (huge pages) bug in fs dax"
>>=20
>> And here is the body.  I just sent directly to the list so there
>> is no URL (if I should be engaging in a different way, please let me know=
):
>=20
> I found it :) at
> https://www.mail-archive.com/nvdimm@lists.linux.dev/msg02743.html
>=20
>=20
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>> Folks - I posted already on nvdimm, but perhaps the topic did not quite g=
rab
>> anyone's attention.  I had had some trouble figuring all the details to g=
et
>> dax mapping of files from an xfs file system with underlying Optane DC me=
mory
>> going, but now have that working reliably.  But there is an odd behavior:=

>>=20
>> When first mapping a file, I request mapping a 32 Gb range, aligned on a 1=
 Gb
>> (and thus clearly on a 2 Mb) boundary.
>>=20
>> For each group of 8 Gb, the first 4095 entries map with a 2 Mb huge (PMD)=

>> page.  The 4096th one does FALLBACK.  I suspect some problem in
>> dax.c:grab_mapping_entry or its callees, but am not personally well enoug=
h
>> versed in either the dax code or the xarray implementation to dig further=
.
>>=20
>>=20
>> If you'd like a second puzzle =F0=9F=98=84 ... after completing this mapp=
ing, another
>> thread accesses the whole range sequentially.  This results in NOPAGE fau=
lt
>> handling for the first 4095+4095 2M regions that previously resulted in
>> NOPAGE -- so far so good.  But it gives FALLBACK for the upper 16 Gb (exc=
ept
>> the two PMD regions it alrady gave FALLBACK for).
>>=20
>>=20
>> I can provide trace output from a run if you'd like and all the ndctl, gd=
isk
>> -l, fdisk -l, and xfs_info details if you like.
>>=20
>>=20
>> In my application, it would be nice if dax.c could deliver 1 Gb PUD size
>> mappings as well, though it would appear that that would require more sur=
gery
>> on dax.c.  It would be somewhat analogous to what's already there, of cou=
rse,
>> but I don't mean to minimize the possible trickiness of it.  I realize I
>> should submit that request as a separate thread =F0=9F=98=84 which I inte=
nd to do
>> later.
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>>=20
>> Regards - Eliot Moss

