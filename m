Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH] mm, memory-failure: clarify error message
References: <1558066095-9495-1-git-send-email-jane.chu@oracle.com>
 <512532de-4c09-626d-380f-58cef519166b@arm.com>
From: Jane Chu <jane.chu@oracle.com>
Message-ID: <a2be5833-2161-38b6-2569-46084207ee47@oracle.com>
Date: Mon, 20 May 2019 18:53:14 -0700
MIME-Version: 1.0
In-Reply-To: <512532de-4c09-626d-380f-58cef519166b@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Anshuman Khandual <anshuman.khandual@arm.com>, n-horiguchi@ah.jp.nec.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 5/16/2019 9:48 PM, Anshuman Khandual wrote:

> On 05/17/2019 09:38 AM, Jane Chu wrote:
>> Some user who install SIGBUS handler that does longjmp out
> What the longjmp about ? Are you referring to the mechanism of catching the
> signal which was registered ?

Yes.

thanks,
-jane
