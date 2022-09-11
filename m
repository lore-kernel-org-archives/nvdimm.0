Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36F47F
	for <nvdimm@lists.linux.dev>; Sun, 11 Sep 2022 15:09:01 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id f24so6282706plr.1
        for <nvdimm@lists.linux.dev>; Sun, 11 Sep 2022 08:09:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=tnxEpb6pf+fpk/khg6S5+1VA2aKHrO1P36M1MNHRA7w=;
        b=LN3RqRl7hKDKroLuz7T0z9u2DHQUiotxxjHKKEiy1pSsZpt8NflhAA3blsP8bzqzjo
         EyaO46zH6ETPqs767sNYTAbG3dU5QzrfTPPYi8H3HL33OeYnqRXbU9KqrJYHPlzfch2X
         25fu0Qsse743I5YmX+Ee/loFFMipl9Nv1ntUkacR189Iy+9IjAnZ6z9sb6zyEGqiui2H
         Can5oAZzxUVKi6s9/dJX8AGWPJ1Lid4CEh42Say+d9eNOHHL5gIL4WFsPJ1ORCdCY6+l
         mDxI0PwenPbp+crU4DkJkqBv+AcK9mL/dBhI2sVtStC+Rnq3hgAWXMF9jvU2CA+wdT1V
         eXVg==
X-Gm-Message-State: ACgBeo0ufKwMQKu8ai/ooBNo4ZNsdL/R97gqnbfIZLIggcMFFiWtonDJ
	9ywFDeByNESJDVA8e9xgQk8=
X-Google-Smtp-Source: AA6agR4rNPwx9VPnzfHkI3k7LIuzmTO9M+flEcD9XHbrrV7UG17q720pcwe/Vi78YoliZsPp6zC+Rg==
X-Received: by 2002:a17:90b:4a85:b0:202:4f3f:1f65 with SMTP id lp5-20020a17090b4a8500b002024f3f1f65mr19425015pjb.241.1662908941218;
        Sun, 11 Sep 2022 08:09:01 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id d19-20020aa797b3000000b0053ea3d2ecd6sm3533917pfq.94.2022.09.11.08.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Sep 2022 08:09:00 -0700 (PDT)
Message-ID: <fd1d7c49-a090-e8c7-415b-dfcda94ace9d@acm.org>
Date: Sun, 11 Sep 2022 08:08:58 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC PATCH 2/7] RDMA/rxe: Convert the triple tasklets to
 workqueues
To: Yanjun Zhu <yanjun.zhu@linux.dev>,
 Daisuke Matsuda <matsuda-daisuke@fujitsu.com>, linux-rdma@vger.kernel.org,
 leonro@nvidia.com, jgg@nvidia.com, zyjzyj2000@gmail.com
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 rpearsonhpe@gmail.com, yangx.jy@fujitsu.com, lizhijian@fujitsu.com,
 y-goto@fujitsu.com
References: <cover.1662461897.git.matsuda-daisuke@fujitsu.com>
 <41e5476f4f14a0b77f4a8c3826e3ef943bf7c173.1662461897.git.matsuda-daisuke@fujitsu.com>
 <0b3366e6-c0ae-7242-5006-b638e629972d@linux.dev>
Content-Language: en-US
In-Reply-To: <0b3366e6-c0ae-7242-5006-b638e629972d@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/22 00:10, Yanjun Zhu wrote:
> I also implemented a workqueue for rxe. IMO, can we add a variable to
> decide to use tasklet or workqueue?
> 
> If user prefer using tasklet, he can set the variable to use
> tasklet. And the default is tasklet. Set the variable to another
> value to use workqueue.

I'm in favor of removing all uses of the tasklet mechanism because of 
the disadvantages of that mechanism. See also:
* "Eliminating tasklets" (https://lwn.net/Articles/239633/).
* "Modernizing the tasklet API" (https://lwn.net/Articles/830964/).
* Sebastian Andrzej Siewior's opinion about tasklets 
(https://lore.kernel.org/all/YvovfXMJQAUBsvBZ@linutronix.de/).

Thanks,

Bart.

