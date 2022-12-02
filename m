Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BC44C71
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 15:59:50 +0000 (UTC)
Received: by mail-qv1-f48.google.com with SMTP id r15so3676865qvm.6
        for <nvdimm@lists.linux.dev>; Fri, 02 Dec 2022 07:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=cPzx2hLWGTaW5By9gQFzFihvIZmO3/hpOtbLChgMY3Q=;
        b=jZZhbejWjetSz80O5+Jxno73nWvt+U32Cob/W4y51jinbfaHMI2W/x1YWri4uT7SPt
         fHqLa18VLNR0ILy0OJzwN0lJ6uWdY2JDB52+xPJ0U8Si78pVc0KSdTkUg3RB2TkqCXEm
         WP96XT/9zqK98AaNkZXqw8mG4kaHgs0H+TtBUem+gVQOEiCES8kvRR40wt9Rm7d1bRFC
         PKELCorf1MUpa647ljULaZOj4Yk+85Qc4cOlULfEiOtm0SYDQlZxuvpwL6BBlVmZ7eFK
         +kTUHJlm3VBNrOOGPqtBpDjGkE283wbAstS9F6bSevoObX9YXwC4OvMzngV9isPiAa20
         z9hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cPzx2hLWGTaW5By9gQFzFihvIZmO3/hpOtbLChgMY3Q=;
        b=6g2EgS/hjv8K1vrY0U1o+IO595F7rTsl5KT5X/U5dx6dEAcKPkPc62Snlk1FdWK94/
         ggMkvXQy6xYLbS6PJ725EJSj08IQvEvF2AnySyFBIbTBmyaV7tmFU3wW4V11AbQL/LVn
         jdwyKnsCLC7oEh9QP1D2rp/sNB3ImiEvg5scU4LbaJq+vX4Z0td/W6mumzcIBQsW8URZ
         6xQi037SWCLCxKCJRgD7aHcK33VY/EnexMG1Qz5Dj1CQ82IfzaQazH4lDOzA95dEFan3
         HJfuqLS3qZcl1v0qak/nwD08kqw48Zt3TRsRlomhWe2wKzdqQnbvCXSUbw25PiJFVS0R
         XlIw==
X-Gm-Message-State: ANoB5pnKQUfnl+5Ymd4GS7RoiCa8sTsRM4NVKXdXrcsk074uxHkDYzQG
	ey+PAifqgxPWgrZdNKt+zMXq3eBOzC4=
X-Google-Smtp-Source: AA0mqf6SsV+WqvUyoTAF2WBT88zFIvRitZ0GyO5yfJdonHYg3h94MGW5cHcALI9zI5Z9CRz5ldyx4g==
X-Received: by 2002:a05:6214:310d:b0:4bc:1455:43c6 with SMTP id ks13-20020a056214310d00b004bc145543c6mr47083119qvb.89.1669996789168;
        Fri, 02 Dec 2022 07:59:49 -0800 (PST)
Received: from [10.230.45.5] ([38.32.73.2])
        by smtp.gmail.com with ESMTPSA id bk17-20020a05620a1a1100b006f9f3c0c63csm5842768qkb.32.2022.12.02.07.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 07:59:48 -0800 (PST)
Sender: Alexander Motin <mavbsd@gmail.com>
From: Alexander Motin <mav@FreeBSD.org>
X-Google-Original-From: Alexander Motin <mav@ixsystems.com>
Message-ID: <454036c5-ab16-db4a-f0db-b6640a6d5a57@ixsystems.com>
Date: Fri, 2 Dec 2022 10:59:47 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev
References: <20221117210935.5717-1-mav@ixsystems.com>
 <Y3awuiWbbJFcqJdt@aschofie-mobl2>
 <8de44383-d2a6-2dfd-098d-f221232fafbf@ixsystems.com>
Organization: iXsystems, Inc.
Subject: Re: [ndctl PATCH] libndctl/msft: Improve "smart" state reporting
In-Reply-To: <8de44383-d2a6-2dfd-098d-f221232fafbf@ixsystems.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17.11.2022 17:41, Alexander Motin wrote:
> On 17.11.2022 17:07, Alison Schofield wrote:
>> On Thu, Nov 17, 2022 at 04:09:36PM -0500, Alexander Motin wrote:
>>> Previous code reported "smart" state based on number of bits
>>> set in the module health field.  But actually any single bit
>>> set there already means critical failure.  Rework the logic
>>> according to specification, properly reporting non-critical
>>> state in case of warning threshold reached, critical in case
>>> of any module health bit set or error threshold reached and
>>> fatal if NVDIMM exhausted its life time.  In attempt to
>>> report the cause of failure in absence of better methods,
>>> report reached thresholds as more or less matching alarms.
>>>
>>> While there clean up the code, making it more uniform with
>>> others and allowing more methods to be implemented later.
>>
>> Hi Alexander,
>>
>> Perhaps this would be better presented in 2 patches:
>> 1)the cleanup and then 2) improvement of smart state reporting.
> 
> Done.
Pardon my ignorance about the processes here, but what's about review on 
on the merits after two weeks?  Any more thoughts after I fixed the 
"procedural issue":
https://lore.kernel.org/nvdimm/20221117223749.6783-1-mav@ixsystems.com/T/#t

Thanks.

-- 
Alexander Motin
