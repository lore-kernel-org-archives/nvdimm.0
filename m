Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C7D8F60
	for <nvdimm@lists.linux.dev>; Thu,  2 Feb 2023 18:39:07 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id e6so2753683plg.12
        for <nvdimm@lists.linux.dev>; Thu, 02 Feb 2023 10:39:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=44Tbffij6x8u6hWa9nzBypn4C/WCHwZ/yEGRnTnWNXY=;
        b=EI06uy3YaAGeMJTK+PFegtKGa93Q93Uj+XyDktl2AsXdSuHH+Ru6bmnuF/kkKXZOEM
         ANEaFx9/fTX3qqg/U8i3LkBkO7Qi7hB9yOLZ5ig/klmh9lxtEISlniU0Y+lhN73Bpjmx
         8IrguqM+8LElblZGyRbFlmiCfd5TmxfAepUD0Lb1ehITSPiehSqryAZW/akOQkFcnp80
         r0vpoeDk12KQxsg2NJ3QXMwCEmO+ZbYjfbyk1Rtr0hYNADvfLa4c9RTrg6C5KD7py+ap
         /0ReotklA19K711MvHhYd97X3pFKrT7D3xrakjhJAltN3k9BvCqxlodCiXcvHVgOgcSX
         kLHw==
X-Gm-Message-State: AO0yUKWe+ea7Iv4Q/F5JwOwA07a8iNCs3XaZuwIx4tsHeDuWpQVL7mpx
	Pyyi6tkBgkeCRAuTlCo42Tw=
X-Google-Smtp-Source: AK7set8fNbiiFYW7OdcSiJFzCCcd6PnkVskd+HRqyruGtnlqpt0Vn1V/D3WSUtrSKyM8at7NMHKKxw==
X-Received: by 2002:a17:902:c403:b0:196:6599:3538 with SMTP id k3-20020a170902c40300b0019665993538mr8710126plk.22.1675363146577;
        Thu, 02 Feb 2023 10:39:06 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:bf7f:37aa:6a01:bf09? ([2620:15c:211:201:bf7f:37aa:6a01:bf09])
        by smtp.gmail.com with ESMTPSA id l2-20020a170902ec0200b00198a96c6b7csm4082247pld.305.2023.02.02.10.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 10:39:05 -0800 (PST)
Message-ID: <8540c721-6bb9-3542-d9bd-940b59d3a7a4@acm.org>
Date: Thu, 2 Feb 2023 10:39:02 -0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [dm-devel] [PATCH 0/9] Documentation: correct lots of spelling
 errors (series 2)
Content-Language: en-US
To: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com, netdev@vger.kernel.org,
 Zefan Li <lizefan.x@bytedance.com>, sparclinux@vger.kernel.org,
 Neeraj Upadhyay <quic_neeraju@quicinc.com>, Alasdair Kergon
 <agk@redhat.com>, Dave Jiang <dave.jiang@intel.com>,
 linux-scsi@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Guenter Roeck <linux@roeck-us.net>, linux-media@vger.kernel.org,
 Jean Delvare <jdelvare@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Mike Snitzer
 <snitzer@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
 linux-raid@vger.kernel.org, Tejun Heo <tj@kernel.org>,
 Jiri Pirko <jiri@nvidia.com>, cgroups@vger.kernel.org,
 Dan Williams <dan.j.williams@intel.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>, linux-hwmon@vger.kernel.org,
 rcu@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-usb@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Vinod Koul <vkoul@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 dmaengine@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
References: <20230129231053.20863-1-rdunlap@infradead.org>
 <875yckvt1b.fsf@meer.lwn.net>
 <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/2/23 10:33, Randy Dunlap wrote:
> On 2/2/23 10:09, Jonathan Corbet wrote:
>> Randy Dunlap <rdunlap@infradead.org> writes:
>>>   [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>>>   [PATCH 7/9] Documentation: scsi: correct spelling
>>
>> I've left these for the SCSI folks for now.  Do we *really* want to be
>> fixing spelling in ChangeLog files from almost 20 years ago?
> 
> That's why I made it a separate patch -- so the SCSI folks can decide that...

How about removing the Documentation/scsi/ChangeLog.* files? I'm not 
sure these changelogs are still useful since these duplicate information 
that is already available in the output of git log ${driver_directory}.

Thanks,

Bart.


