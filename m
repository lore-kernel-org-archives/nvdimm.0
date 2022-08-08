Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B247A
	for <nvdimm@lists.linux.dev>; Mon,  8 Aug 2022 18:33:17 +0000 (UTC)
Received: by mail-qk1-f180.google.com with SMTP id z7so1748113qki.11
        for <nvdimm@lists.linux.dev>; Mon, 08 Aug 2022 11:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=mTBuc/YjazV4B5Z0SpCpYJndKM/Ze/7Cyi3qZ0S4go8=;
        b=Pi+b0kaTVMtfmQyTHjEBd0l8rkdZi1Dzn+0thxdX26i5LPWE+hasFIf2E9btJdOoMW
         gH+OrzhjYIBIhUOxOQl30Vh5SlKy+VZHUi91zHNXARgWd4P1I9wY0NhVIQEp3+zieupN
         cI/d/AOJiH/fCrsjeZilqmQvI3YshF0jCvqZr+gbc+TTepRl3qWM2ueEylKyAvm3Io94
         JnBmgp+t0EOCfzmYPP4CCh5c7CNoHbqfTjHAPib21U77wdhY+WpqpErgL8kYD5ZaERrg
         wy2Z4g3y3zflWbwXCk7P9TSOhd6o2rr4epCNUQqKmM6tvTJO2DGvfMasuegFTlMEd684
         jl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=mTBuc/YjazV4B5Z0SpCpYJndKM/Ze/7Cyi3qZ0S4go8=;
        b=pfXjeBaEYyh8CsbwaduTd+aSQ0qm9wdoXtJfZRezS7NleKt6rGSl3627nSkNqu3UO2
         hSUhJuA+8CpkXbxDkcg1FEk8qXouy4eCul8/FsSIR5PcMraJtcTv9uAQS+2k6i0oTzI2
         kR83mK4y3stlFcRVpEb8mC448IVkKIVjZmdbSNtoLeEDzCmlrq6IdxDMxyjbyH3C9rTE
         txMOX1N7Y7eMsV8jvfmyEe8JdR6KXWyb9CgJo2H+2gFgtBTBPkJTG0pS/3f9ctEPuY/f
         eMKYQiC9jXkwdYOuKu/lPWISzGYZy2TcUOIjC4AEdvI9x72/MbWJemyg/a/uIpp6ozF4
         hWaQ==
X-Gm-Message-State: ACgBeo3VTfMF2fSzNcc68/X9pZNC5s7y/ulKGw9DELf0Tm5CHnFEMC4g
	9Qbfd/Cm9LJzQcfJgxX1jQ==
X-Google-Smtp-Source: AA6agR4tU3frXaUe8iEjHlozZ6W6Fur6lEL16E+6LxRukASSHH9myyVNCp1kuhu1AaWcJ6cJQjDHDQ==
X-Received: by 2002:a05:620a:25d4:b0:6ab:8b17:3724 with SMTP id y20-20020a05620a25d400b006ab8b173724mr15059326qko.395.1659983595966;
        Mon, 08 Aug 2022 11:33:15 -0700 (PDT)
Received: from [192.168.1.210] (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id w19-20020a05620a445300b006b9264191b5sm7231016qkp.32.2022.08.08.11.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 11:33:15 -0700 (PDT)
Message-ID: <8c8f61e5-2c24-de89-1c7d-532c319a3b70@gmail.com>
Date: Mon, 8 Aug 2022 14:33:14 -0400
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v5 24/32] tools/testing/nvdimm: Convert to printbuf
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, pmladek@suse.com
Cc: Dave Hansen <dave.hansen@linux.intel.com>, nvdimm@lists.linux.dev
References: <20220808024128.3219082-1-willy@infradead.org>
 <20220808024128.3219082-25-willy@infradead.org>
 <62f15649dbce8_1b3c294d4@dwillia2-xfh.jf.intel.com.notmuch>
From: Kent Overstreet <kent.overstreet@gmail.com>
In-Reply-To: <62f15649dbce8_1b3c294d4@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/8/22 14:30, Dan Williams wrote:
> Matthew Wilcox (Oracle) wrote:
>> From: Kent Overstreet <kent.overstreet@gmail.com>
>>
>> This converts from seq_buf to printbuf. Here we're using printbuf with
>> an external buffer, meaning it's a direct conversion.
>>
>> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: nvdimm@lists.linux.dev
> 
> My Acked-by still applies:
> 
> https://lore.kernel.org/all/62b61165348f4_a7a2f294d0@dwillia2-xfh.notmuch/
> 
> ...and Shivaprasad's Tested-by should still apply:
> 
> https://lore.kernel.org/all/b299ebe2-88e5-c2bd-bad0-bef62d4acdfe@linux.ibm.com/

Whoops - got them now, thanks!
