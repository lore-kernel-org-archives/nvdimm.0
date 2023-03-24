Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA40517DB
	for <nvdimm@lists.linux.dev>; Fri, 24 Mar 2023 03:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1679629386; i=@fujitsu.com;
	bh=bxzmXSa3ZwSz991itm/RTXkehnzWZlevRaLCWUBrqVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=sEMHNvMCWJIXxLzL1phw959WOY1QQgwD5jQbyKTXN2IvhkiuBX7ofWn4d/8b5Z8u/
	 x2XOqXIcZcHzTQ17DKTTMQulOnzHrrrXxhF+1OEeKzy84N42Fvc1hF5KCIyHtzU84T
	 1cYcJGACbldqeMv4CH6RryBPMrrtLx50We55ZsL9m4lvBfjgQZpZ9Taa/LW6VDYh8i
	 egEzs+EKenRisVs6I4sV+SYIJl8YXjLTwGL0OGiaZpjwEnn5KFrqv62kiM8o0BIs22
	 8EJyUfKMW9jKh2cN4ink09XhNryGrYon6fxSbXSqJPDIzkzrv1NRkMSa0D5vKd9DQ+
	 12tJQs2HC4pGg==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRWlGSWpSXmKPExsViZ8ORqOsuI5t
  isOaApcWc9WvYLKZPvcBocfkJn8Xs6c1MFnv2nmSxWPnjD6vF7x9z2BzYPTav0PJYvOclk8em
  VZ1sHidm/GbxeLF5JqPHmQVH2D0+b5ILYI9izcxLyq9IYM3o2X2BreAVb0Xn/m/MDYxruLsYu
  TiEBLYwSkxp/MIC4Sxnkvj5dDYThLONUeLx3LWMXYycHLwCdhJd806wgtgsAqoSC59vY4KIC0
  qcnPmEBcQWFUiWOHa+la2LkYNDWCBU4ugaR5CwiECIRNOnE2AlzAL1Eqvn/ASzhQSuMEn82Rg
  OYrMJ6EhcWPAXbDyngInE/XeH2SDqLSQWvznIDmHLSzRvnc0MYksIKElc/HqHFcKukGicfogJ
  wlaTuHpuE/MERqFZSK6bhWTULCSjFjAyr2I0LU4tKkst0jXUSyrKTM8oyU3MzNFLrNJN1Est1
  S1PLS7RNdJLLC/WSy0u1iuuzE3OSdHLSy3ZxAiMrpRi5Yk7GFf0/tU7xCjJwaQkyisRKp0ixJ
  eUn1KZkVicEV9UmpNafIhRhoNDSYL3gJRsipBgUWp6akVaZg4w0mHSEhw8SiK80mJAad7igsT
  c4sx0iNQpRkUpcd4EkD4BkERGaR5cGyy5XGKUlRLmZWRgYBDiKUgtys0sQZV/xSjOwagkzDtP
  AmgKT2ZeCdz0V0CLmYAWO9fIgCwuSURISTUwCaYp72Kx51OU4QgzmRhR6C3+ne/7XQt9hR2qj
  2SPKnvVnueavebING6nTU8miWeKBiTuCzNKOK7g1R7suu50CXtGvuRN4T0/1jGk9Wm/+vprZe
  KGN/3XxGp+fG9QVb1fJujhEHQnzuTsjT1HKos4Vy46pGX0JkBtzZkFxkzR5Yv17+a3/DQ9bFi
  /vuOBQdy/jz5ermcVlae0nf59dI9UWLvp3ktTL968PJUxRllOQbRiefnfN5sl7RbaHH+6S1Jg
  xcQVsT/eHDn5gKfK9W3IIef6a8eXfGMV17nx+te1jU5Koe9UVXQYPfaf/NeyUq/DmSu4pcrDy
  svpPdvmzBgphQuMmuHix7XM//jvfbRdiaU4I9FQi7moOBEAawP9uqkDAAA=
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-6.tower-548.messagelabs.com!1679629383!53613!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.104.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 1740 invoked from network); 24 Mar 2023 03:43:03 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-6.tower-548.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 24 Mar 2023 03:43:03 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id 9525710019E;
	Fri, 24 Mar 2023 03:43:03 +0000 (GMT)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121 [10.183.43.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id 891DB100182;
	Fri, 24 Mar 2023 03:43:03 +0000 (GMT)
Received: from [192.168.50.5] (10.167.234.230) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Fri, 24 Mar 2023 03:43:00 +0000
Message-ID: <4aee7cfd-09d6-43a1-3d8c-15fe5274446b@fujitsu.com>
Date: Fri, 24 Mar 2023 11:42:53 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] fsdax: unshare: zero destination if srcmap is HOLE or
 UNWRITTEN
To: Matthew Wilcox <willy@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <jack@suse.cz>, <djwong@kernel.org>
References: <1679483469-2-1-git-send-email-ruansy.fnst@fujitsu.com>
 <20230322160311.89efea3493db4c4ccad40a25@linux-foundation.org>
 <a41f0ea1-c704-7a2e-db6d-93e8bd4fcdea@fujitsu.com>
 <20230323151112.1cc3cf57b35f2dc704ff1af8@linux-foundation.org>
 <a30006e8-2896-259e-293b-2a5d873d42aa@fujitsu.com>
 <ZB0aB7DzhzuyaM9Z@casper.infradead.org>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <ZB0aB7DzhzuyaM9Z@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.234.230]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173)
X-Virus-Scanned: ClamAV using ClamSMTP



在 2023/3/24 11:33, Matthew Wilcox 写道:
> On Fri, Mar 24, 2023 at 09:50:54AM +0800, Shiyang Ruan wrote:
>>
>>
>> 在 2023/3/24 6:11, Andrew Morton 写道:
>>> On Thu, 23 Mar 2023 14:50:38 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>>>
>>>>
>>>>
>>>> 在 2023/3/23 7:03, Andrew Morton 写道:
>>>>> On Wed, 22 Mar 2023 11:11:09 +0000 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>>>>>
>>>>>> unshare copies data from source to destination. But if the source is
>>>>>> HOLE or UNWRITTEN extents, we should zero the destination, otherwise the
>>>>>> result will be unexpectable.
>>>>>
>>>>> Please provide much more detail on the user-visible effects of the bug.
>>>>> For example, are we leaking kernel memory contents to userspace?
>>>>
>>>> This fixes fail of generic/649.
>>>
>>> OK, but this doesn't really help.  I'm trying to determine whether this
>>> fix should be backported into -stable kernels and whether it should be
>>> fast-tracked into Linus's current -rc tree.
>>>
>>> But to determine this I (and others) need to know what effect the bug
>>> has upon our users.
>>
>> I didn't get any bug report form users.  I just found this by running
>> xfstests.  The phenomenon of this problem is: if we funshare a reflinked
>> file which contains HOLE extents, the result of the HOLE extents should be
>> zero but actually not (unexpectable data).
> 
> You still aren't answering the question.  If this did happen to a user,
> what would they see in the file?  Random data?  Something somebody else
> wrote some time ago?  A copy of /etc/passwd, perhaps?  A copy of your
> credit card number?

Ok.  If this happenned to a user, the HOLE or UNWRITTEN part will be old 
data of the new allocated extent because it didn't be cleared.


--
Thanks,
Ruan.
